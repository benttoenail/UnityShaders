Shader "Custom/BSCImageEffect" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Brightness("Brightness", Range(0.0, 1)) = 1.0
		_Contrast("Contrast", Range(0.0, 1)) = 1.0
		_Saturation("Saturation", Range(0.0, 1)) = 1.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }

		Pass
			{
			CGPROGRAM

			#pragma vertex vert_img
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
			

			uniform sampler2D _MainTex;
			fixed _Brightness;
			fixed _Contrast;
			fixed _Saturation;


			float3 ConSatBright(float3 c, float brt, float sat, float con) 
			{
				//Increase or decrease these vaules to 
				//adjust RGB seperately 
				float avgR = 0.5;
				float avgG = 0.5;
				float avgB = 0.5;

				//Luminance coefficients for getting luminance from the image
				//Based on CIE color matching functions
				//Standard throughout the industry 
				float3 LumCoeff = float3(0.2125, 0.7154, 0.0721);

				// - - BRIGHTNESS - - //
				float avgLumin = float3(avgR, avgG, avgB);
				float3 brtColor = c * brt;
				float intensityf = dot(brtColor, LumCoeff);
				float3 intensity = float3(intensityf, intensityf, intensityf);

				// - - SATUARATION - - //	
				float3 satColor = lerp(intensity, brtColor, sat);

				// - - CONTRAST - - //
				float3 conColor = lerp(avgLumin, satColor, con);

				return conColor;
			}


			fixed4 frag(v2f_img i) : COLOR
			{
				fixed4 renderTex = tex2D(_MainTex, i.uv);

				renderTex.rgb = ConSatBright(renderTex.rgb, _Brightness, _Contrast, _Saturation);

				return renderTex;
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
