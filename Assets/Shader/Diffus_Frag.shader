// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/Diffus_Frag" {
     SubShader{
         pass{
             Tags{
                 "LightMode"="ForwardBase"
             }
             CGPROGRAM

             #pragma vertex  vert
             #pragma fragment frag
             #include "unitycg.cginc"
             #include "lighting.cginc"

             struct v2f{
                 float4 pos: POSITION;                
                 float3 normal:NORMAL;
                 float4 vertex:COLOR;
             };

             v2f vert(appdata_base v){
                 v2f o;
                 o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
                //o.color=v.COLOR;
                 o.normal=v.normal;
                 o.vertex=v.vertex;
                 return o;
             }

             fixed4 frag(v2f IN):COLOR{
                 fixed4  col= UNITY_LIGHTMODEL_AMBIENT;
                 float3  N=UnityObjectToWorldNormal(IN.normal);
                 float3 L=normalize(WorldSpaceLightDir(IN.vertex));
                 float diffuseScale=saturate(dot( N,L));

                 col+=_LightColor0*diffuseScale;
                
                return col;
             }

             ENDCG
         }
     }
}
