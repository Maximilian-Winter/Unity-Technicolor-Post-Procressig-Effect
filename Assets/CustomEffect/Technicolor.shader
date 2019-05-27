Shader "Hidden/Custom/Technicolor"
{
	HLSLINCLUDE

	#include "..\PostProcessing/Shaders/StdLib.hlsl"
	TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
	float _techniAmount;
	int _techniPower;
	float _redNegativeAmount;
	float _greenNegativeAmount;
	float _blueNegativeAmount;

	#define cyanfilter float3(0.0, 1.30, 1.0)
	#define magentafilter float3(1.0, 0.0, 1.05) 
	#define yellowfilter float3(1.6, 1.6, 0.05)

	#define redorangefilter float2(1.05, 0.620) //RG_
	#define greenfilter float2(0.30, 1.0)       //RG_
	#define magentafilter2 magentafilter.rb     //R_B

	float4 Frag(VaryingsDefault i) : SV_Target
	{
		float4 colorInput = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);
		
		float3 tcol = colorInput.rgb;
		
		float2 rednegative_mul = tcol.rg * (1.0 / (_redNegativeAmount * _techniPower));
		float2 greennegative_mul = tcol.rg * (1.0 / (_greenNegativeAmount * _techniPower));
		float2 bluenegative_mul = tcol.rb * (1.0 / (_blueNegativeAmount * _techniPower));

		float rednegative = dot(redorangefilter, rednegative_mul);
		float greennegative = dot(greenfilter, greennegative_mul);
		float bluenegative = dot(magentafilter2, bluenegative_mul);

		float3 redoutput = rednegative.rrr + cyanfilter;
		float3 greenoutput = greennegative.rrr + magentafilter;
		float3 blueoutput = bluenegative.rrr + yellowfilter;

		float3 result = redoutput * greenoutput * blueoutput;
		colorInput.rgb = lerp(tcol, result, _techniAmount);
		
		return colorInput;
	}
		ENDHLSL

		SubShader
	{
		Cull Off ZWrite Off ZTest Always

			Pass
		{
			HLSLPROGRAM

			#pragma vertex VertDefault
			#pragma fragment Frag

			ENDHLSL
		}
	}
}