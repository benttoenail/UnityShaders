﻿Shader "Benttoenail/TexturedShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_ScrollYSpeed("Y Scroll Speed", Range(0,10)) = 2
		_ScrollXSpeed("X Scroll Speed", Range(0,10)) = 2
	}

		SubShader{
			Tags { "RenderType" = "Opaque" }
			LOD 200

			CGPROGRAM
			// Physically based Standard lighting model, and enable shadows on all light types
			#pragma surface surf Standard fullforwardshadows

			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0

			fixed _ScrollYSpeed;
			fixed _ScrollXSpeed;
			sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		fixed4 _Color;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed2 scrolledUV = IN.uv_MainTex;

			fixed xScrollValue = _ScrollXSpeed * _Time;
			fixed yScrollValue = _ScrollYSpeed * _Time;

			scrolledUV += fixed2(xScrollValue, yScrollValue);

			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, scrolledUV) * _Color;
			o.Albedo = c.rgb;

			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
