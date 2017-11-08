Shader "Benttoenail/CustomShader" {
	Properties{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_NormalMap ("Bump", 2D) = "Bump" {}
	}
	SubShader{
		Tags {"RenderType" = "Opaque"}
		LOD 200
		 
		CGPROGRAM
		#pragma surface surf Lambert fullforwardshadows
		#pragma target 3.0

		float4 _Color;
		sampler2D _MainTex;
		sampler2D _NormalMap;

		struct Input {
			float2 uv_MainTex;
			float2 uv_NormalMap;
		};


		void surf(Input IN, inout SurfaceOutput o){
			fixed4 mainTex = tex2D(_MainTex, IN.uv_MainTex);

			o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap)); 
			o.Albedo = mainTex * _Color.rgb; 
		}

		ENDCG
		
	}
	Fallback "Diffuse"
}