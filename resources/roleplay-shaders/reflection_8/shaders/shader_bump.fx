// reflective bump test 2_5
// By ren712

#define GENERATE_NORMALS   
#include "mta-helper.fx"


float xval = 0.0;
float yval = 0.0;
float bFac =0.45;
float xzoom = 1;
float yzoom = 1;
float brFac = 0.5; // 0.32
float efInte = 0.7; // 0.56

texture sReflectionTexture;

sampler2D envMap = sampler_state
{
    Texture = (sReflectionTexture);
    AddressU = Mirror;
    AddressV = Mirror;
    AddressW = Wrap;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
};

sampler2D baseMap = sampler_state
{
    Texture = (gTexture0);
    AddressU = Wrap;
    AddressV = Wrap;
    AddressW = Wrap;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
};


struct VS_INPUT 
{
    float4 Position : POSITION0;
    float4 Color : COLOR0;
    float2 Texcoord : TEXCOORD0;
    float3 Normal : NORMAL0; 
};

struct VS_OUTPUT 
{
    float4 Position : POSITION0;
    float2 Texcoord : TEXCOORD0;
    float3 TexCoord_proj:TEXCOORD1;
    float4 Diffuse: TEXCOORD3;
    float DistFade: TEXCOORD4;
    float3 Normal : TEXCOORD2;
    float3 Binormal : TEXCOORD5;
    float3 Tangent : TEXCOORD6;
};

VS_OUTPUT vertex_shader( VS_INPUT Input )
{
    VS_OUTPUT Output;
    MTAFixUpNormal( Input.Normal );
   
    Output.Position = mul(Input.Position, gWorldViewProjection);
    Output.Texcoord = Input.Texcoord;
    float3 worldPosition =mul(float4(Input.Position.xyz,1), gWorld).xyz;
  
    float4 Po = float4(Input.Position.xyz,1.0);
    float4 pPos = mul(Po, gWorldViewProjection); 

    Output.TexCoord_proj.x = 0.5 * (pPos.w + pPos.x);
    Output.TexCoord_proj.y = 0.5 * (pPos.w - pPos.y);
    Output.TexCoord_proj.z = pPos.w;
	
    // Fake tangent and binormal
    float3 Normal;
    float3 Tangent = Input.Normal.yxz;
    Tangent.xz = Input.Texcoord.xy;
    float3 Binormal = normalize( cross(Tangent, Input.Normal) );
    Tangent = normalize( cross(Binormal, Input.Normal) );
    // first rows are the tangent and binormal scaled by the bump scale
	
    Output.Tangent = normalize(mul(Tangent, gWorldInverseTranspose).xyz);
    Output.Binormal = normalize(mul(Binormal, gWorldInverseTranspose).xyz);
    Output.Normal = normalize( mul(Input.Normal, (float3x3)gWorld) );
	
    float DistanceFromCamera = MTACalcCameraDistance( gCameraPosition, worldPosition );
    Output.DistFade = MTAUnlerp ( 190, 110, DistanceFromCamera );
    Output.Diffuse = MTACalcGTABuildingDiffuse( Input.Color );
    return( Output );
}


struct PS_INPUT 
{
    float2 Texcoord : TEXCOORD0;
    float3 TexCoord_proj:TEXCOORD1;
    float4 Diffuse: TEXCOORD3;
    float DistFade: TEXCOORD4;
    float3 Normal : TEXCOORD2;
    float3 Binormal : TEXCOORD5;
    float3 Tangent : TEXCOORD6;
};

float TextureSize=512.0;

// The Sobel filter extracts the first order derivates of the image,
// that is, the slope. The slope in X and Y directon allows us to
// given a heightmap evaluate the normal for each pixel. This is
// the same this as ATI's NormalMapGenerator application does,
// except this is in hardware.
//
// These are the filter kernels:
//
//  SobelX       SobelY
//  1  0 -1      1  2  1
//  2  0 -2      0  0  0
//  1  0 -1     -1 -2 -1

float3 ComputeNormalsPS(float2 texCoord,float4 lightness)
{
   float off = 1.0 / TextureSize;

   // Take all neighbor samples
   float4 s00 = tex2D(baseMap, texCoord + float2(-off, -off));
   float4 s01 = tex2D(baseMap, texCoord + float2( 0,   -off));
   float4 s02 = tex2D(baseMap, texCoord + float2( off, -off));

   float4 s10 = tex2D(baseMap, texCoord + float2(-off,  0));
   float4 s12 = tex2D(baseMap, texCoord + float2( off,  0));

   float4 s20 = tex2D(baseMap, texCoord + float2(-off,  off));
   float4 s21 = tex2D(baseMap, texCoord + float2( 0,    off));
   float4 s22 = tex2D(baseMap, texCoord + float2( off,  off));

   // Slope in X direction
   float4 sobelX = s00 + 2 * s10 + s20 - s02 - 2 * s12 - s22;
   // Slope in Y direction
   float4 sobelY = s00 + 2 * s01 + s02 - s20 - 2 * s21 - s22;

   // Weight the slope in all channels, we use grayscale as height
   float sx = dot(sobelX, lightness);
   float sy = dot(sobelY, lightness);

   // Compose the normal
   float3 normal = normalize(float3(sx, sy, 1));

   // Pack [-1, 1] into [0, 1]
   return float3(normal * 0.5 + 0.5);
}

float4 pixel_shader( PS_INPUT Input ) : COLOR0
{   
    float4 fvBaseColor = tex2D( baseMap, Input.Texcoord )*Input.Diffuse;
    float3 fvNormal = ComputeNormalsPS(Input.Texcoord,fvBaseColor)* 2.0 - 1.0;
    fvNormal = normalize(float3(fvNormal.x * bFac, fvNormal.y * bFac, fvNormal.z)); 

    float3 LightDir = normalize(float3(1.0f, 1.0, 0.8f));   
    LightDir.xy = gCameraDirection.xy;
	
    float  fNDotL = dot( fvNormal, LightDir); 
    float3 sTexture = float3((Input.TexCoord_proj.xy / Input.TexCoord_proj.z),0) ;
    sTexture += (fvNormal.x * Input.Tangent+ fvNormal.y * Input.Binormal );	
    sTexture.xy += float2(xval,yval);
    sTexture.xy *= float2(xzoom,yzoom);
    float4 texel = tex2D(envMap,sTexture)*(brFac);
    float lum = (texel.r + texel.g + texel.b)/3;
    float adj = saturate( lum - 0.1 );
    adj = adj / (1.01 - 0.3);
    texel = texel * adj;
    texel+=0.17;

    float4 fvTotalAmbient   = saturate((fvBaseColor)/1.4); 
    float4 fvTotalDiffuse= (Input.Diffuse *texel)*efInte;

    float4 outPut=saturate(fvTotalAmbient*fNDotL) +saturate(Input.DistFade)*fvTotalDiffuse;  
    outPut.a=fvBaseColor.a;
    return outPut;
}

technique reflective_bump_test2_5
{
   pass P0
   {
        VertexShader = compile vs_2_0 vertex_shader();
        PixelShader = compile ps_2_0 pixel_shader();
   }
}
