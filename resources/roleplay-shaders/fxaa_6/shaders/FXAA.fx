///////////////////////////////////////////////////////////////////////////
// Fast-Approximate Anti Aliasing (FXAA) v3
// Original source: Master Effect 1.3 Shader Suite by Marty McFly
///////////////////////////////////////////////////////////////////////////

int2 screenResolution=int2(1920,1080);

//settings:
float FXAA_LINEAR=0;
float FXAA_QUALITY__EDGE_THRESHOLD=(1.0/32.0);
float FXAA_QUALITY__EDGE_THRESHOLD_MIN=(1.0/16.0);
float FXAA_QUALITY__SUBPIX_CAP=(7.0/8.0);
float FXAA_QUALITY__SUBPIX_TRIM=(1.0/12.0);
#define FXAA_QUALITY__SUBPIX_TRIM_SCALE 	(1.0/(1.0 - FXAA_QUALITY__SUBPIX_TRIM))
float FXAA_SEARCH_STEPS=16;
float FXAA_SEARCH_THRESHOLD=(1.0/4.0);

#include "mta-helper.fx"
//--------------------------------------------------------------------------------------
// Textures
//--------------------------------------------------------------------------------------
texture sTex0 :TEX0;

//--------------------------------------------------------------------------------------
// Sampler Inputs
//--------------------------------------------------------------------------------------

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
 
PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;
    PS.Position = mul(float4(VS.Position, 1), gWorldViewProjection);
    PS.TexCoord = VS.TexCoord;
    return PS;
}


float4 PixelShaderFunction(PSInput PS) : COLOR0
{
float4 ScreenSize=float4(screenResolution.x,(1/screenResolution.x),(screenResolution.x/screenResolution.y),(screenResolution.y/screenResolution.x));
#define FxaaTexTop(t, p) tex2Dlod(t, float4(p, 0.0, 0.0))
#define FxaaTexOff(t, p, o, r) tex2Dlod(t, float4(p + (o * r), 0, 0))

float2 pos = PS.TexCoord.xy;

float2 rcpFrame = float2(1/ScreenSize.x, ScreenSize.z/ScreenSize.x);
float4 rcpFrameOpt = float4(2/ScreenSize.x, 2*ScreenSize.z/ScreenSize.x, 0.5/ScreenSize.x, 0.5*ScreenSize.z/ScreenSize.x);

float lumaN = dot(FxaaTexOff(InputSampler, pos.xy, float2(0, -1), rcpFrame.xy).xyz, float3(0.299, 0.587, 0.114));
float lumaW = dot(FxaaTexOff(InputSampler, pos.xy, float2(-1, 0), rcpFrame.xy).xyz, float3(0.299, 0.587, 0.114));


float4 rgbyM;
rgbyM.xyz = FxaaTexTop(InputSampler, pos.xy).xyz;
rgbyM.w = dot(rgbyM.xyz, float3(0.299, 0.587, 0.114));
float lumaE = dot(FxaaTexOff(InputSampler, pos.xy, float2( 1, 0), rcpFrame.xy).xyz, float3(0.299, 0.587, 0.114));
float lumaS = dot(FxaaTexOff(InputSampler, pos.xy, float2( 0, 1), rcpFrame.xy).xyz, float3(0.299, 0.587, 0.114));
float lumaM = rgbyM.w;


float rangeMin = min(lumaM, min(min(lumaN, lumaW), min(lumaS, lumaE)));
float rangeMax = max(lumaM, max(max(lumaN, lumaW), max(lumaS, lumaE)));
float range = rangeMax - rangeMin;

if(range < max(FXAA_QUALITY__EDGE_THRESHOLD_MIN, rangeMax * FXAA_QUALITY__EDGE_THRESHOLD)) return rgbyM;


float lumaNW = dot(FxaaTexOff(InputSampler, pos.xy, float2(-1,-1), rcpFrame.xy).xyz, float3(0.299, 0.587, 0.114));
float lumaNE = dot(FxaaTexOff(InputSampler, pos.xy, float2( 1,-1), rcpFrame.xy).xyz, float3(0.299, 0.587, 0.114));
float lumaSW = dot(FxaaTexOff(InputSampler, pos.xy, float2(-1, 1), rcpFrame.xy).xyz, float3(0.299, 0.587, 0.114));
float lumaSE = dot(FxaaTexOff(InputSampler, pos.xy, float2( 1, 1), rcpFrame.xy).xyz, float3(0.299, 0.587, 0.114));



float lumaL = (lumaN + lumaW + lumaE + lumaS) * 0.25;
float rangeL = abs(lumaL - lumaM);
float blendL = saturate((rangeL / range) - FXAA_QUALITY__SUBPIX_TRIM) * FXAA_QUALITY__SUBPIX_TRIM_SCALE;
blendL = min(FXAA_QUALITY__SUBPIX_CAP, blendL);

float edgeVert = abs(lumaNW + (-2.0 * lumaN) + lumaNE) + 2.0 * abs(lumaW + (-2.0 * lumaM) + lumaE ) + abs(lumaSW + (-2.0 * lumaS) + lumaSE);
float edgeHorz = abs(lumaNW + (-2.0 * lumaW) + lumaSW) + 2.0 * abs(lumaN + (-2.0 * lumaM) + lumaS ) + abs(lumaNE + (-2.0 * lumaE) + lumaSE);
bool horzSpan = edgeHorz >= edgeVert;

float lengthSign = horzSpan ? -rcpFrame.y : -rcpFrame.x;
if(!horzSpan) lumaN = lumaW;
if(!horzSpan) lumaS = lumaE;
float gradientN = abs(lumaN - lumaM);
float gradientS = abs(lumaS - lumaM);
lumaN = (lumaN + lumaM) * 0.5;
lumaS = (lumaS + lumaM) * 0.5;

bool pairN = gradientN >= gradientS;
if(!pairN) lumaN = lumaS;
if(!pairN) gradientN = gradientS;
if(!pairN) lengthSign *= -1.0;
float2 posN;
posN.x = pos.x + (horzSpan ? 0.0 : lengthSign * 0.5);
posN.y = pos.y + (horzSpan ? lengthSign * 0.5 : 0.0);


gradientN *= FXAA_SEARCH_THRESHOLD;

float2 posP = posN;
float2 offNP = horzSpan ?
float2(rcpFrame.x, 0.0) :
float2(0.0f, rcpFrame.y);
float lumaEndN;
float lumaEndP;
bool doneN = false;
bool doneP = false;
posN += offNP * (-1.5);
posP += offNP * ( 1.5);
for(int i = 0; i < FXAA_SEARCH_STEPS; i++)
{
lumaEndN = dot(FxaaTexTop(InputSampler, posN.xy).xyz, float3(0.299, 0.587, 0.114));
lumaEndP = dot(FxaaTexTop(InputSampler, posP.xy).xyz, float3(0.299, 0.587, 0.114));
bool doneN2 = abs(lumaEndN - lumaN) >= gradientN;
bool doneP2 = abs(lumaEndP - lumaN) >= gradientN;
if(doneN2 && !doneN) posN += offNP;
if(doneP2 && !doneP) posP -= offNP;
if(doneN2 && doneP2) break;
doneN = doneN2;
doneP = doneP2;
if(!doneN) posN -= offNP * 2.0;
if(!doneP) posP += offNP * 2.0;
}

float dstN = horzSpan ? pos.x - posN.x : pos.y - posN.y;
float dstP = horzSpan ? posP.x - pos.x : posP.y - pos.y;

bool directionN = dstN < dstP;
lumaEndN = directionN ? lumaEndN : lumaEndP;

if(((lumaM - lumaN) < 0.0) == ((lumaEndN - lumaN) < 0.0))
lengthSign = 0.0;

float spanLength = (dstP + dstN);
dstN = directionN ? dstN : dstP;
float subPixelOffset = 0.5 + (dstN * (-1.0/spanLength));
subPixelOffset += blendL * (1.0/8.0);
subPixelOffset *= lengthSign;
float3 rgbF = FxaaTexTop(InputSampler, float2(pos.x + (horzSpan ? 0.0 : subPixelOffset), pos.y + (horzSpan ? subPixelOffset : 0.0))).xyz;

if (FXAA_LINEAR == 1) {
lumaL *= lumaL;
}
float lumaF = dot(rgbF, float3(0.299, 0.587, 0.114)) + (1.0/(65536.0*256.0));
float lumaB = lerp(lumaF, lumaL, blendL);
float scale = min(4.0, lumaB/lumaF);
rgbF *= scale;


return float4(rgbF, lumaM);
}

technique FXAA
{
  pass P0
  {
	VertexShader = compile vs_3_0 VertexShaderFunction();
	PixelShader  = compile ps_3_0 PixelShaderFunction();

	FogEnable=FALSE;
	ALPHATESTENABLE=FALSE;
	SEPARATEALPHABLENDENABLE=FALSE;
	AlphaBlendEnable=FALSE;
	FogEnable=FALSE;
	SRGBWRITEENABLE=FALSE;
	}
}
