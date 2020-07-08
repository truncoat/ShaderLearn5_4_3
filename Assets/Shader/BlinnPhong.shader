// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

 

Shader "Custom/BlinnPhong" {

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
                 float3 L=normalize(UnityWorldSpaceLightDir(v.vertex));//_WorldSpaceLightPos0这个变量的含义是，这是一个表示世界做表中光源的位置矢量或者方向向量
                 float3 N=UnityObjectToWorldNormal(v.normal);//补0 是为了 矩阵乘法能够成立
                  float3 V=normalize( WorldSpaceViewDir(v.vertex));
                 o.color= UNITY_LIGHTMODEL_AMBIENT; //环境光先计算
                 //diffuse color
                 o.color=_LightColor0*saturate(dot(N,L));//漫反射光
                  
                // float3 R= 2*dot(N,L)*N-L; 
                float3 H=normalize(L+V);
                
              
                 float specularScale= pow(saturate(dot(H,N)),_Shininess);//的树在0-1的情况下 再四次方 让得数无尽趋近于 0
                 o.color+=_SpecularColor*specularScale;//高光
                 return o;
             }

             fixed4 frag(v2f IN):COLOR{
                 // return  IN.color+UNITY_LIGHTMODEL_AMBIENT;
                 return  IN.color;
             }

             ENDCG
         }
     }
}
