// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/NewSurfaceShader" {
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
                 fixed4 color:COLOR;
             };

             v2f vert(appdata_base v){
                 v2f o;
                 o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
                 float3 N=normalize(v.normal);//得到法向量（模型坐标）
                 float3 L=normalize(_WorldSpaceLightPos0);//得到光照向量（世界坐标）
                 N=mul(unity_ObjectToWorld,N);//同一法向量和光照向量
                 float ndotl=saturate(dot(N,L));//  saturate 作用是将值卡在 0-1之间 
                o.color=_LightColor0*ndotl;// 平行光计算
                // o.color.rgb=ShadeVertexLights(v.vertex,v.normal);
                float3 wPos=mul(unity_ObjectToWorld,v.vertex).xyz;
                //平行光与 其他光源 相加 即得到混合光效果
                o.color.rgb+=Shade4PointLights(unity_4LightPosX0,unity_4LightPosY0,unity_4LightPosZ0,
                                                             unity_LightColor[0].rgb,unity_LightColor[1].rgb,unity_LightColor[2].rgb,unity_LightColor[3].rgb,
                                                             unity_4LightAtten0,
                                                             wPos,N);
                 return o;
             }

             fixed4 frag(v2f IN):COLOR{
                  return  IN.color+UNITY_LIGHTMODEL_AMBIENT;
             }

             ENDCG
         }
     }
}
