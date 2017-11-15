Shader "Benttoenail/SimpleFragShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}
	SubShader{

		Pass{
			CGPROGRAM
			//Assign Vertex and Fragment functions
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			half4 _Color;
			sampler2D _MainTex;

			//Take the input data into structure 
			//Decorate each field with a Bind Semantic
			//which marks variables to initialize with certain data
			struct vertInput {
				float4 pos: POSITION; //Vertex position
				float2 texcoord : TEXCOORD0; //UV coordinates
			};

			struct vertOutput {
				float4 pos : SV_POSITION;
				float2 texcoord : TEXCOORD0;
			};

			//Vertex function projects coordinates of model to the screen
			vertOutput vert(vertInput input) {
				vertOutput o;
				//Converts model coordinates to view/screen coordinates
				o.pos = UnityObjectToClipPos(input.pos);
				o.texcoord = input.texcoord;
				return o;
			}

			//Fragment shader color the pixels on screen
			//depending on position of verticies
			half4 frag(vertOutput output) : COLOR {
				half4 c = tex2D(_MainTex, output.texcoord);
				return c * _Color;
			}
			ENDCG
		}		
	}
}
