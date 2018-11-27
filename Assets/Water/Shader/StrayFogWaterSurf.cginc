﻿#pragma target 4.6
#include "StrayFogCameraDepthTexture.cginc"
#include "StrayFogRiver.cginc"
//Water
sampler2D _WaterNormal;
float _WaterNormalScale;
float _WaterAngle;
float _WaterSpeed;
float _WaterRefraction;

//Tessellate Mesh
float _TessEdgeLength;
float _TessMaxDisp;
float _TessPhongStrength;

//Water
sampler2D _CameraDepthTexture;
sampler2D _GrabTex;
float4 _GrabTex_TexelSize;

//Light
float4 _Specular;
half _Smoothness;
half _Occlusion;

struct Input {
	half2 uv_WaterNormal;
	half2 uv_WaterFoam;
	float3 worldNormal;
	float3 viewDir;
	float3 worldPos;
	INTERNAL_DATA
	float4 vertexColor : COLOR;
	float4 screenPos;
};
// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
UNITY_INSTANCING_BUFFER_START(Props)
// put more per-instance properties here
UNITY_INSTANCING_BUFFER_END(Props)

float2 RotationVector(float2 vec, float angle)
{
	float radZ = radians(-angle);
	float sinZ, cosZ;
	sincos(radZ, sinZ, cosZ);
	return float2(vec.x * cosZ - vec.y * sinZ,
		vec.x * sinZ + vec.y * cosZ);
}

//tessellate计算
float4 tessFunction(appdata_full v0, appdata_full v1, appdata_full v2)
{
	return UnityEdgeLengthBasedTessCull(v0.vertex, v1.vertex, v2.vertex, _TessEdgeLength, _TessMaxDisp);
}

void tessVert(inout appdata_full v)
{	
	/*v.vertex.xyz += GerstnerWave(v.vertex,half3(1,1,1),
		_GSteepness, _GAmplitude, _GFrequency, _GSpeed, _GDirectionAB, _GDirectionCD);*/
}

void tessSurf(Input IN, inout SurfaceOutputStandardSpecular o) {
	//linearEyeDepth 像素深度
	float linearEyeDepth = StrayFogLinearEyeDepth(_CameraDepthTexture, IN.screenPos);
	float iTime = _Time.y;
	half2 uv_WaterNormal = IN.uv_WaterNormal;

	fixed4 normalSample = tex2D(_WaterNormal, uv_WaterNormal);

	o.Normal = Tonemap(UnpackScaleNormal(normalSample, _WaterNormalScale));


	/*float4 _FarBumpSampleParams = float4(0.25, 0.01, 0, 0);
	float2 _FinalBumpSpeed01 = RotationVector(float2(0, 1), _WaterAngle + 10).xy * _WaterSpeed;

	fixed4 farSample = tex2D(_WaterNormal,
		FBM(uv_WaterNormal, 0.5) +
		_Time.x * _FinalBumpSpeed01 * _FarBumpSampleParams.x);

	fixed4 normalSample = tex2D(_WaterNormal, FBM(uv_WaterNormal, 0.5) + farSample.rg * 0.05);
	normalSample = lerp(normalSample, farSample, saturate(linearEyeDepth * _FarBumpSampleParams.y));

	o.Normal = UnpackScaleNormal(normalSample, _WaterNormalScale);*/

	//o.Normal = UnpackScaleNormal(tex2D(_WaterNormal,FBM(uv_WaterNormal, 0.5)), _WaterNormalScale);

	/*float t = _Time.x / 4;
	float2 uv_WaterNormal = IN.uv_WaterNormal;
	uv_WaterNormal += t * 0.2;
	float4 c1 = tex2D(_WaterNormal, uv_WaterNormal);
	uv_WaterNormal += t * 0.3;
	float4 c2 = tex2D(_WaterNormal, uv_WaterNormal);
	uv_WaterNormal += t * 0.4;
	float4 c3 = tex2D(_WaterNormal, uv_WaterNormal);
	c1 += c2 - c3;
	float4 normal = (c1.x + c1.y + c1.z) / 3;

	o.Normal = UnpackNormal(normal).xyz;*/

	/*half fresnelFac = saturate(dot(IN.viewDir, o.Normal));

	float4 grabUV = IN.screenPos;
	grabUV.xy += o.Normal.xz * _GrabTex_TexelSize.xy * _WaterRefraction;
	grabUV.xy /= grabUV.w;
	float4 waterGrabColor = tex2Dproj(_GrabTex, grabUV);*/

	//o.Emission = lerp(waterGrabColor *0.5,waterGrabColor, fresnelFac);




	//half fresnel = sqrt(1.0 - dot(-normalize(IN.viewDir), o.Normal));


	/*float4 _FarBumpSampleParams = float4(0.25, 0.01, 0, 0);
	float2 _FinalBumpSpeed01 = RotationVector(float2(0, 1), _WaterAngle + 10).xy * _WaterSpeed;
	half2 uv_WaterNormal = IN.uv_WaterNormal;

	fixed4 farSample = tex2D(_WaterNormal,
		uv_WaterNormal +
		_Time.x * _FinalBumpSpeed01 * _FarBumpSampleParams.x);

	fixed4 normalSample = tex2D(_WaterNormal, uv_WaterNormal + farSample.rg * 0.05);
	normalSample = lerp(normalSample, farSample,saturate(linearEyeDepth * _FarBumpSampleParams.y));

	fixed3 lerp_WaterNormal = UnpackScaleNormal(normalSample,_WaterNormalScale);
	o.Normal = lerp_WaterNormal;*/

	//float4 grabUV = IN.screenPos;	
	//grabUV.xy += o.Normal.xz * _WaterRefraction;
	//grabUV.xy += o.Normal.xz * _GrabTex_TexelSize.xy * _WaterRefraction;

	//float4 waterGrabColor = tex2D(_GrabTex, grabUV);

	//half range = saturate(_WaterDepth * linearEyeDepth);
	//range = 1.0 - range;
	//range = lerp(range, pow(range,3), 0.5);

	//// Calculate the color tint
	//half4 waterColor= lerp(_WaterDeepColor, _WaterShallowColor, range);

	//o.Normal = GerstNormal(uv_WaterNormal);
	//o.Emission = UnpackNormal(tex2D(_WaterNormal, GerstNormal(uv_WaterNormal)));

	//o.Emission = lerp(waterGrabColor, waterGrabColor*0.6, saturate(fresnel));

	/*uv_WaterNormal = 0.5 - uv_WaterNormal;
	float color = 3.0 - (3.*length(2.* uv_WaterNormal));

	float3 coord = float3(atan(uv_WaterNormal.y / uv_WaterNormal.x) / 6.2832 + .5, length(uv_WaterNormal)*.4, .5);

	for (int i = 1; i <= 7; i++)
	{
		float power = pow(2.0, float(i));
		color += (1.5 / power) * snoise(coord + float3(0., -iTime * .05, iTime*.01), power*16.);
	}
	o.Emission = float3(color, pow(max(color, 0.), 2.)*0.4, pow(max(color, 0.), 3.)*0.15);*/

	o.Specular = _Specular;
	o.Smoothness = _Smoothness;
	o.Occlusion = _Occlusion;
	o.Alpha = 1;
}