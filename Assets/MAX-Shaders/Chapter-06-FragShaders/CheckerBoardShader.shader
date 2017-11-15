Shader "Benttoenail/CheckerBoardShader" {
	Properties {
		_Density("Density", Range(2, 50)) = 2
	}
	SubShader{

		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct v2f{
				float2 uv : TEXCOORD;
				float4 vertex : SV_POSITION;
			};

			float _Density;

			v2f vert(float4 pos : POSITION, float2 uv : TEXCOORD0) {
				v2f o;
				o.vertex = UnityObjectToClipPos(pos);
				o.uv = uv * _Density;
				return o;
			}

			half4 frag(v2f i) : SV_TARGET {
				float2 c = i.uv;
				c = floor(c) / 2;
				float checker = frac(c.x + c.y) * 2;
				return checker;
			}
			ENDCG
		}		
	}
}
