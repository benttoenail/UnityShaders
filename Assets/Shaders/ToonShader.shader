Shader "Benttoenail/ToonShader" {
	Properties {
		_CelShadingLevels("Cell shading", Range(0, 10)) = 0.5
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}
		SubShader{
			Tags { "RenderType" = "Opaque" }
			LOD 200

			CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Toon

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _RampTex;
		sampler2D _MainTex;
		float _CelShadingLevels;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex);
		}

		half4 LightingToon(SurfaceOutput s, half3 lightDir, half atten) {
			half NdotL = dot(s.Normal, lightDir);
			//NdotL = tex2D(_RampTex, fixed2(NdotL, 0.5));
			half cel = floor(NdotL * _CelShadingLevels) / (_CelShadingLevels - 0.5);

			fixed4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * cel * atten;
			c.a = s.Alpha;

			return c;
		}

		ENDCG
	}
	FallBack "Diffuse"
}
