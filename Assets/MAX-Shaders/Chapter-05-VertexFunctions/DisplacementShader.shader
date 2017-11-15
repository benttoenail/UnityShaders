Shader "Benttoenail/DisplacementShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_Displace ("Displacement Amount", Range(-1, 1)) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float4 vertColor;
		};

		fixed4 _Color;
		float _Displace;

		void vert(inout appdata_full v, out Input o) {
			UNITY_INITIALIZE_OUTPUT(Input, o);
			v.vertex.xyz += v.normal * _Displace;
			o.vertColor = _Color;
		}


		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			o.Albedo = IN.vertColor.rgb * _Color;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
