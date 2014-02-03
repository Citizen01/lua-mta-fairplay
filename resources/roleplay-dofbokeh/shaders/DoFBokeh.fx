///////////////////////////////////////////////////////////////////////////
// Bokeh Depth of Field
// Original source: Master Effect 1.3 Shader Suite by Marty McFly
// Credits: 'Matso' for DoF code
///////////////////////////////////////////////////////////////////////////

// Basic settings:
bool DoF_Auto = true;		
bool DoF_Vignetting = false;
int vignint = 4;

// Depth speciffic:
int znear = 100;
int zfar = 3500;
float focalDepth = 90; 
float focalLength = 80; 
float fstop = 90; 
float CoC = 0.1;

// Blur speciffic:
float namount = 0.00004;
int DOFdownsample = 4;
float maxblur = 2.5;
#define samples  6
#define rings 2
float threshold = 2.5;
float gain = 0.1;
float bias = 0.2;
float fringe = 0.5; 

// Don't change that
float4 ScreenSize=float4(1920,(1/1920),(1920/1080),(1080/1920));
float3 sLumPixel=float3(0,0,0);
static float PI = 3.14159265;
static float FlipSize = ScreenSize.w*ScreenSize.x;
static float2 screenRes = {ScreenSize.x,FlipSize};
float2 texelSmp = float2(0.0009765625,0.00130208333333333333333333333333);

//#define DoF_TestMode

#include "mta-helper.fx"

//-- These two are set by MTA
texture gDepthBuffer : DEPTHBUFFER;
matrix gProjectionMainScene : PROJECTION_MAIN_SCENE;
// -- Input texture
texture sTex0 :TEX0;

//-------------------------------------------------------------------------------------------------------
// Sampler Inputs
//-------------------------------------------------------------------------------------------------------

sampler2D InputSampler = sampler_state
{
    Texture = (sTex0);
    MinFilter = POINT;
    MagFilter = POINT;
    MipFilter = POINT;
    AddressU   = Clamp;
	AddressV   = Clamp;
	SRGBTexture=FALSE;
	MaxMipLevel=0;
	MipMapLodBias=0;
};

sampler2D SamplerDepth = sampler_state
{
	Texture   = (gDepthBuffer);
    MinFilter = POINT;
    MagFilter = POINT;
    MipFilter = NONE;
    AddressU   = Clamp;
	AddressV   = Clamp;
	SRGBTexture=FALSE;
	MaxMipLevel=0;
	MipMapLodBias=0;

};

struct VSInput
{
    float3 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
};

struct PSInput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
};
 
//-------------------------------------------------------------------------------------------------------
//-- Vertex shader
//-------------------------------------------------------------------------------------------------------

PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;
    PS.Position = mul(float4(VS.Position, 1), gWorldViewProjection);
    PS.TexCoord = VS.TexCoord;
    return PS;
}

//-----------------------------------------------------------------------------
//-- Get value from the depth buffer
//-- Uses define set at compile time to handle RAWZ special case (which will use up a few more slots)
//-----------------------------------------------------------------------------
float FetchDepthBufferValue( float2 uv )
{
    float4 texel = tex2D(SamplerDepth, uv);
#if IS_DEPTHBUFFER_RAWZ
    float3 rawval = floor(255.0 * texel.arg + 0.5);
    float3 valueScaler = float3(0.996093809371817670572857294849, 0.0038909914428586627756752238080039, 1.5199185323666651467481343000015e-5);
    return dot(rawval, valueScaler / 255.0);
#else
    return texel.r;
#endif
}
 
//-----------------------------------------------------------------------------
//-- Use the last scene projecion matrix to linearize the depth value a bit more
//-----------------------------------------------------------------------------
float LinearizeDV(float posZ)
{
    return gProjectionMainScene[3][2] / (posZ - gProjectionMainScene[2][2]);
}

//-----------------------------------------------------------------------------
//-- Highlight terrain parts based on relative position spread from camera
//-----------------------------------------------------------------------------
float DepthSpread( float dbuf, float from, float to)
{
    if ( from == to )
        return 1.0;
    else
        return saturate(( dbuf - from ) / ( to - from ));
}

//--------------------------------------------------------------------------------------
// Functions from the effect_functions.txt
//--------------------------------------------------------------------------------------

float linearize(float depth, int near, int far)
{
	return -far * near / (depth * (far - near) - far);
}


 
float2 rand(float2 coord) //generating noise/pattern texture for dithering
{
	float noiseX = ((frac(3.0-coord.x*(screenRes.x/0.2))*3.25)+(frac(coord.y*(screenRes.y/0.2))*3.75))*0.1-0.2;
	float noiseY = ((frac(3.0-coord.x*(screenRes.x/0.2))*3.75)+(frac(coord.y*(screenRes.y/0.2))*3.25))*0.1-0.2;
	
	return float2(noiseX,noiseY);
}


float vignette(float2 coord, float _int)
{
	float2 coords = coord;
	coords = (coords - 0.5) * 2.0;		
	float coordDot = dot (coords,coords);	
	return 1.0 - coordDot * _int * 0.1;
}

float4 colorDof(float2 coords,float blur) //processing the sample
{
	float4 colDF = float4(1,1,1,1);
	
	colDF.x = tex2D(InputSampler,coords + float2(0.0,1.0)*texelSmp*fringe*blur).x;
	colDF.y = tex2D(InputSampler,coords + float2(-0.866,-0.5)*texelSmp*fringe*blur).y;
	colDF.z = tex2D(InputSampler,coords + float2(0.866,-0.5)*texelSmp*fringe*blur).z;
	
	float3 lumcoeff = float3(0.299,0.587,0.114);
	float lum = dot(colDF.xyz,lumcoeff);
	float thresh = max((lum-threshold)*gain, 0.0);
	float3 nullcol = float3(0,0,0);
	colDF.xyz +=lerp(nullcol,colDF.xyz,thresh*blur);
	return colDF;
}


//-------------------------------------------------------------------------------------------------------
//-- Pixel shader
//-------------------------------------------------------------------------------------------------------

float4 PixelShaderFunction(PSInput PS) : COLOR0
{
	float preDepth = LinearizeDV(FetchDepthBufferValue(PS.TexCoord.xy));
	float depth = linearize(preDepth,znear,zfar);
	
	float fDepth = focalDepth ;
	float fLength = focalLength ;
	
	float blur = 2.0;
	
	float f = fLength ; //focal length in mm
	float d = fDepth*1000; //focal plane in mm
	float o = depth*1000; //depth in mm
		
	float a = (o*f)/(o-f); // depth
	float b = (d*f)/(d-f); // focal depth
	float c = (d-f)/(d*fstop*CoC); 
		
	blur = abs(a-b)*c;

	if (DoF_Auto) 
	{
		float fBlur = blur * saturate( - 0.2 + (1 - sLumPixel.g)) ;
		float nBlur = 1-saturate(0.015 * preDepth) * sLumPixel.g ;
		blur = lerp( fBlur, nBlur, sLumPixel.g );
	}
	
	blur = saturate(blur);	

	float2 noise = rand(PS.TexCoord.xy)*namount*blur;
	
	float w = (1.0/screenRes.x)*blur*maxblur+noise.x;
	float h = (1.0/screenRes.y)*blur*maxblur+noise.y;
	
	float4 col = float4(0,0,0,1);
	
	if(blur < 0.05) //some optimization thingy
	{
		col = tex2D(InputSampler, PS.TexCoord.xy);
	}
	else
	{
	col = tex2D(InputSampler, PS.TexCoord.xy);
	float s = 1.0;
	int ringsamples;
	for (int i = 1; i <= rings; i += 1)
	{
		ringsamples = i * samples;
		for (int j = 0 ; j < ringsamples ; j += 1)
		{
			float step = PI*2.0 / ringsamples;
			float pw = cos(j*step)*i;
			float ph = sin(j*step)*i;
			col.xyz += colorDof(PS.TexCoord.xy + float2(pw*w,ph*h),blur).xyz;  
			s += 1.0*lerp(1.0,i/rings,bias);
		}
	}
	col.rgb = col.rgb/s; //divide by sample count
	}
	
	if (DoF_Vignetting) { col.rgb *= vignette(PS.TexCoord.xy,vignint); }

	#ifdef DoF_TestMode
		return float4(sLumPixel.g,blur,0,1);
	#else
		return col;
	#endif
}

//-------------------------------------------------------------------------------------------------------
//-- Technique
//-------------------------------------------------------------------------------------------------------

technique DoFBokeh
{	
	pass P0
	{
		VertexShader = compile vs_3_0 VertexShaderFunction();
		PixelShader  = compile ps_3_0 PixelShaderFunction();
	}
}