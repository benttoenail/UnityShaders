Shader "Benttoenail/HolographicShader" {
	Properties{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_DotProduct("Rim Effect", Range(-1, 1)) = 0.25
	}
	SubShader{
		Tags {	
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}

		Cull off
		LOD 200
		 
		CGPROGRAM
		#pragma surface surf Lambert alpha:fade nolighting
		#pragma target 3.0		
		
		float4 _Color;
		sampler2D _MainTex;
		float _DotProduct;

		struct Input {
			float2 uv_MainTex;
			float3 worldNormal;
			float3 viewDir;
		};


		void surf(Input IN, inout SurfaceOutput o){
			float4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;

			float border = 1 - (abs(dot(IN.viewDir,
				IN.worldNormal)));
			float alpha = (border * (1 - _DotProduct) + _DotProduct);
			o.Alpha = c.a * alpha;
		}

		ENDCG
		
	}
	Fallback "Diffuse"
	
}