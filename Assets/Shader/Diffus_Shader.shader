﻿// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

 

Shader "Custom/Diffus_Shadow" {
     SubShader{
         //pass{
         //    Tags{
         //    "LightMode"="ShadowCaster"
         //    }
         //}
         pass{
             Tags{
                 "LightMode"="ForwardBase"
             }
             CGPROGRAM             
             #pragma multi_compile_fwdbase
             #pragma vertex  vert
             #pragma fragment frag
             #pragma multi_compile_fwdbase
             #include "unitycg.cginc"
             #include "lighting.cginc"
             #include "UnityShaderVariables.cginc"
             #include "AutoLight.cginc"

             struct v2f{
                 float4 pos: POSITION;
                 fixed4 color:COLOR;
                // unityShadowCoord3 _LightCoord : TEXCOORD0;
                 //unityShadowCoord3 _LightCoord : TEXCOORD1;
                 LIGHTING_COORDS(0,1)
             };

             v2f vert(appdata_base v){
                 v2f o;
                 o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
                 float3 N=normalize(v.normal);
                 float3 L=normalize(_WorldSpaceLightPos0);//_WorldSpaceLightPos0这个变量的含义是，这是一个表示世界做表中光源的位置矢量或者方向向量
                 N=normalize(mul(float4(N,0),unity_WorldToObject).xyz);//补0 是为了 矩阵乘法能够成立
                o.color=_LightColor0*saturate(dot(N,L));
                 //o.color.rgb=ShadeVertexLights(v.vertex,v.normal) ;
                 // o.color.rgb= o.color.rgb/2;
                 float3 wpos=mul(unity_ObjectToWorld,v.vertex).xyz;


                 o.color.rgb+= Shade4PointLights(unity_4LightPosX0,unity_4LightPosY0,unity_4LightPosZ0,//系统提供的获取 4个光源位置信息的参数 为4个光源位置的 分量数组
                                                                 unity_LightColor[0].rgb,unity_LightColor[1].rgb,unity_LightColor[2].rgb,unity_LightColor[3].rgb,
                                                                 unity_4LightAtten0,//光源衰减顺序
                                                                 wpos,N);
                  TRANSFER_SHADOW(o)
                 return o;
             }

             fixed4 frag(v2f IN):COLOR{
                 float atten =SHADOW_ATTENUATION(IN);
                  fixed4 color=(IN.color+UNITY_LIGHTMODEL_AMBIENT);
                  color.rgb*=atten;
                  return color;
             }

             ENDCG
         }


           pass{
             Tags{
                 "LightMode"="ForwardAdd"
             }
             CGPROGRAM             
             #pragma multi_compile_fwdbase
             #pragma vertex  vert
             #pragma fragment frag
             #pragma multi_compile_fwdbase_fullshadows
             #include "unitycg.cginc"
             #include "lighting.cginc"
             #include "UnityShaderVariables.cginc"
             #include "AutoLight.cginc"

             struct v2f{
                 float4 pos: POSITION;
                 fixed4 color:COLOR;
                // unityShadowCoord3 _LightCoord : TEXCOORD0;
                 //unityShadowCoord3 _LightCoord : TEXCOORD1;
                 LIGHTING_COORDS(0,1)
             };

             v2f vert(appdata_base v){
                 v2f o;
                 o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
                 float3 N=normalize(v.normal);
                 float3 L=normalize(_WorldSpaceLightPos0);//_WorldSpaceLightPos0这个变量的含义是，这是一个表示世界做表中光源的位置矢量或者方向向量
                 N=normalize(mul(float4(N,0),unity_WorldToObject).xyz);//补0 是为了 矩阵乘法能够成立
                o.color=_LightColor0*saturate(dot(N,L));
                 //o.color.rgb=ShadeVertexLights(v.vertex,v.normal) ;
                 // o.color.rgb= o.color.rgb/2;
                 float3 wpos=mul(unity_ObjectToWorld,v.vertex).xyz;


                 o.color.rgb+= Shade4PointLights(unity_4LightPosX0,unity_4LightPosY0,unity_4LightPosZ0,//系统提供的获取 4个光源位置信息的参数 为4个光源位置的 分量数组
                                                                 unity_LightColor[0].rgb,unity_LightColor[1].rgb,unity_LightColor[2].rgb,unity_LightColor[3].rgb,
                                                                 unity_4LightAtten0,//光源衰减顺序
                                                                 wpos,N);
                  TRANSFER_SHADOW(o)
                 return o;
             }

             fixed4 frag(v2f IN):COLOR{
                 float atten =SHADOW_ATTENUATION(IN);
                  fixed4 color=(IN.color+UNITY_LIGHTMODEL_AMBIENT);
                  color.rgb*=atten;
                  return color;
             }

             ENDCG
         }
     }

     FallBack "Diffuse"
}
