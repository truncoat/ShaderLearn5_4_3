// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/Specular_Frag" {
     Properties{
         _SpecularColor("SpecularColor",Color)=(1,1,1,1)
         _Shininess("Shininess",range(1,32))=8
           _mainColor("mainColor",color)=(1,1,1,1)
     }
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
              fixed4 _mainColor;
             float4 _SpecularColor;
             float _Shininess;
             struct v2f{
                 float4 pos: POSITION;                
                 float3 normal:NORMAL;
                 float4 vertex:COLOR;
             };

             v2f vert(appdata_base v){
                 v2f o;
                 o.pos=mul(UNITY_MATRIX_MVP,v.vertex);              
                 o.normal=v.normal;
                 o.vertex=v.vertex;
                 return o;
             }

             fixed4 frag(v2f IN):COLOR{
                 fixed4  col= UNITY_LIGHTMODEL_AMBIENT*_mainColor;
                 float3  N=UnityObjectToWorldNormal(IN.normal);
                 float3 L=normalize(WorldSpaceLightDir(IN.vertex));
                 float diffuseScale=saturate(dot( N,L));

                 //SpecularLight
                 col+=_LightColor0*diffuseScale;
                
                 float3 V= normalize(WorldSpaceViewDir(IN.vertex));
                 float3 R=normalize( 2*dot(N,L)*N-L);
                 float specularScale=saturate(dot(R,V));

                 col+=_SpecularColor*pow( specularScale,_Shininess);
                 //comupute
                 float3 wpos=mul(unity_ObjectToWorld,IN.vertex).xyz;
                 col.rgb+=Shade4PointLights(unity_4LightPosX0,unity_4LightPosY0,unity_4LightPosZ0,//系统提供的获取 4个光源位置信息的参数 为4个光源位置的 分量数组
                                                                 unity_LightColor[0].rgb,unity_LightColor[1].rgb,unity_LightColor[2].rgb,unity_LightColor[3].rgb,
                                                                 unity_4LightAtten0,//光源衰减顺序
                                                                 wpos,N);                 
                return col;
             }

             ENDCG
         }
     }
}
