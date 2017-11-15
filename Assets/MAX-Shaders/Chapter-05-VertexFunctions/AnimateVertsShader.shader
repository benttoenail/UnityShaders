Shader "Benttoenail/AnimateVertsShader" {
	Properties{
		_MainTint("Global Color Tint", Color) = (1,1,1,1)
		_Speed("Wave Speed", Range(0, 80)) = 5
		_Freq("Wave Frequency", Range(0, 10)) = 2
		_Amp("Wave Amplitude", Range(-1, 1)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert
		#pragma target 3.0

		float4 _MainTint;
		float _Speed;
		float _Freq;
		float _Amp;

		struct Input {
			float2 uv_MainTex;
			float4 vertColor;
		};

		void vert(inout appdata_full v, out Input o)
		{
			//DirectX 11 Initialization
			//Code doesn't work without it
			UNITY_INITIALIZE_OUTPUT(Input, o); 
			
			float t = _Time * _Speed;
			float waveA = (sin(t + v.vertex.y * _Freq) * _Amp) + 1;

			//Move vert in Normal direction * sin motion
			v.vertex.xyz += v.normal * waveA;
			v.normal = normalize(float3(v.normal.x + waveA, v.normal.y, v.normal.z));

			//color verts according to sin wave
			o.vertColor = float4(waveA, waveA, waveA, waveA);
		}

		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = IN.vertColor.rgb * _MainTint.rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
