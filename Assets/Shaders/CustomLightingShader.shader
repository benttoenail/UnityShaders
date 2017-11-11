Shader "Benttoenail/CustomLightingShader" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Atten("Attenuation", Range(0, 1)) = 1
		
	}
		SubShader{
			Tags { "RenderType" = "Opaque" }
			LOD 200

			CGPROGRAM
			// Physically based Standard lighting model, and enable shadows on all light types
			#pragma surface surf SimpleLambert

			float _Atten;
		half4 LightingSimpleLambert(SurfaceOutput s, half3 lightDir, half atten) {
			half NdotL = dot(s.Normal, lightDir);
			half diff = NdotL * 0.5 + 0.5;
			half4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * (atten*_Atten));
			c.a = s.Alpha;
			return c;
		}

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex);
		}

		ENDCG
	}
	FallBack "Diffuse"
}
