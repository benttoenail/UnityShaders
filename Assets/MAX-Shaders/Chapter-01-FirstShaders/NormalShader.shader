Shader "Benttoenail/NormalShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		//Normal Map Properties
		_NormalTex("Normal Map", 2D) = "bump" {}
		_xTile ("Tile X", Range(0, 10)) = 1.0
		_yTile ("Tile Y", Range(0, 10)) = 1.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _NormalTex;

		struct Input {
			float2 uv_MainTex;
			float2 uv_NormalTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		half _xTile;
		half _yTile;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceOutputStandard o) {

			float2 uvNormal = float2(IN.uv_NormalTex.x * _xTile,
									 IN.uv_NormalTex.y * _yTile);

			float2 uvMainTex = float2(IN.uv_MainTex.x * _xTile, 
									 IN.uv_MainTex.y * _yTile);

			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, uvMainTex) * _Color;

			//Get the normal data out of normal Map texture
			//using the UnpackNormal Function
			o.Normal = UnpackNormal(tex2D(_NormalTex, uvNormal));
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
			
		}
		ENDCG
	}
	FallBack "Diffuse"
}
