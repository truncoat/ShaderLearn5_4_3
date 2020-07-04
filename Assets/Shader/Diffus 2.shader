// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

 

Shader "Custom/Diffus_2" {
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

             struct v2f{
                 float4 pos: POSITION;
                 fixed4 color:COLOR;
             };

             v2f vert(appdata_base v){
                 v2f o;
                 o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
                 float3 N=normalize(v.normal);
                 float3 L=normalize(_WorldSpaceLightPos0);//_WorldSpaceLightPos0这个变量的含义是，这是一个表示世界做表中光源的位置矢量或者方向向量
                 N=normalize(mul(float4(N,0),unity_WorldToObject).xyz);//补0 是为了 矩阵乘法能够成立
                // o.color=_LightColor0*saturate(dot(N,L));
                 o.color.rgb=ShadeVertexLights(v.vertex,v.normal) ;
                  o.color.rgb= o.color.rgb/2;
                 return o;
             }

             fixed4 frag(v2f IN):COLOR{
                  return  IN.color+UNITY_LIGHTMODEL_AMBIENT;
             }

             ENDCG
         }
     }
}
