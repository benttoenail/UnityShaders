/*
Triplaner Shader with lighting and Normals
Max Rose
Current Issues

--LIGHTING--
	-Only one directional light works
	-No Ambient lighting 
	-No Specular

--TEXTURES--
	-Normal Maps still don't work
	-  ** Check out "Shader Fundamentals - Normal Mapping" on youtube for more info **
*/

Shader "Benttoenail/TriplanerShader" {
	Properties {
		_MainTex("Main Texture", 2D) = "white"{}
		_Tiling ("Tiling", Float) = 1.0
		_OcclusionMap("Occlusion", 2D) = "white"{}
		_NormalMap("Normal Map", 2D) = "white"{}
	}
	SubShader{

		Pass{
		Tags {"LightMode" = "ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc" //For _LightColor0 

			struct v2f{
				half3 objNormal : TEXCOORD0;
				float3 coords : TEXCOORD1;
				float2 uv : TEXCOORD2;
				float4 pos : SV_POSITION;
				fixed4 diff : COLOR0; //diffuse lighting color
			};

			float _Tiling;

			//Vertex Function
			v2f vert(float4 pos : POSITION, float3 normal : NORMAL, float2 uv : TEXCOORD3, appdata_base v) {

				v2f o;
				o.pos = UnityObjectToClipPos(pos);
				o.coords = pos.xyz * _Tiling;
				o.objNormal = normal;
				o.uv = uv;

				// -- LIGHTING -- //
				
				//Get Vertex normal in worldSpace
				half3 worldNormal = UnityObjectToWorldNormal(v.normal);

				//dot product between normals and lightdirection
				//for Lambert lighting
				half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));

				//Grabbing light color
				o.diff = nl * _LightColor0;
				
				return o;
			}

			sampler2D _MainTex;
			sampler2D _OcclusionMap;
			sampler2D _NormalMap;

			//triplaner texturing
			half4 frag(v2f i) : SV_TARGET {

				//Sample Normal Map
				half3 normal = UnpackNormal(tex2D(_NormalMap, i.uv));

				//abs of normal as texture weights
				half3 blend = abs(i.objNormal);

				//make sure wieghts sum up to one
				blend /= dot(blend, 1.0);

				//set up texture projections
				fixed4 px = tex2D(_MainTex, i.coords.yz);
				fixed4 py = tex2D(_MainTex, i.coords.xz);
				fixed4 pz = tex2D(_MainTex, i.coords.xy);

				//Blend the textures based on weights
				fixed4 c = px * blend.x +
					py * blend.y +
					pz * blend.z;

				//Add AO map
				c *= tex2D(_OcclusionMap, i.uv);

				//Add diffuse lighting
				c *= i.diff;

				return c;
			}
			ENDCG
		}		
	}
}
