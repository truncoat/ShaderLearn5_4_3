﻿// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

 

Shader "Custom/Specular" {

     Properties{
         _SpecularColor("Specular",color)=(1,1,1,1)
         _Shininess("Shininess",Range(1,64))=8
     }
     SubShader{
         pass{
             Tags{
                 "LightMode"="Vertex"
             }
             CGPROGRAM             
             #pragma multi_compile_fwdbase
             #pragma vertex  vert
             #pragma fragment frag
             #include "unitycg.cginc"
             #include "lighting.cginc"
             #include "UnityShaderVariables.cginc"
               float _Shininess;
              float4 _SpecularColor;
             struct v2f{
                 float4 pos: POSITION;
                 fixed4 color:COLOR;
             };

             v2f vert(appdata_base v){
                 v2f o;
                 o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
                // float3 N= normalize(UnityObjectToWorldNormal(v.normal));
                 float3 L=normalize(_WorldSpaceLightPos0);//_WorldSpaceLightPos0这个变量的含义是，这是一个表示世界做表中光源的位置矢量或者方向向量
                 float3 N=normalize(mul(float4(v.vertex.xyz,0),unity_WorldToObject).xyz);//补0 是为了 矩阵乘法能够成立
                 //diffuse color
                 o.color=_LightColor0*saturate(dot(N,L));
                 // Specular color                 
                 //float3 wpos=mul(_Object2World,v.vertex).xyz;
                 float3 I=-WorldSpaceLightDir(v.vertex); // 光方向 是顶点指向光源的  取负 则会反过来
                 float3 R=reflect(I,N);//输入反向光 向量和法线向量
                 float3 V= WorldSpaceViewDir(v.vertex);
                 R=normalize(R);
                 V=normalize(V);
                 float specularScale= pow(saturate(dot(R,V)),_Shininess);//的树在0-1的情况下 再四次方 让得数无尽趋近于 0
                 o.color+=_SpecularColor*specularScale;
                 return o;
             }

             fixed4 frag(v2f IN):COLOR{
                  return  IN.color+UNITY_LIGHTMODEL_AMBIENT;
             }

             ENDCG
         }
     }
}