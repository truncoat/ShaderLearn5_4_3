// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/NewSurfaceShader" {
     Properties{
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
             struct v2f{
                 float4 pos: POSITION;
                 fixed4 color:COLOR;
                 float3 normal:NORMAL;
             };

             v2f vert(appdata_base v){
                 v2f o;
                 o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
                //o.color=v.COLOR;
                 o.normal=v.normal;
                 return o;
             }

             fixed4 frag(v2f IN):COLOR{
                 float3 N=normalize(IN.normal);//得到法向量（模型坐标）
                 float3 L=normalize(_WorldSpaceLightPos0);//得到光照向量（世界坐标）
                 //N=mul(unity_ObjectToWorld,N);//同一法向量和光照向量
                 N=mul(float4(N,0),unity_WorldToObject).xyz;//法向量 直接乘以 世界转换矩阵 会导致不会应用变换   但是反过来就能应用变换 什么逆矩阵的转置矩阵我也不知道为啥
                 N=normalize(N);
                 float ndotl=saturate(dot(N,L));//  saturate 作用是将值卡在 0-1之间 
                fixed4 color1=_LightColor0*ndotl*_mainColor;// 平行光计算
                 IN.color.rgb=ShadeVertexLights(IN.pos,IN.normal);
                float3 wPos=mul(unity_ObjectToWorld,IN.pos).xyz;
                //平行光与 其他光源 相加 即得到混合光效果
                color1.rgb+=Shade4PointLights(unity_4LightPosX0,unity_4LightPosY0,unity_4LightPosZ0,
                                                             unity_LightColor[0].rgb,unity_LightColor[1].rgb,unity_LightColor[2].rgb,unity_LightColor[3].rgb,
                                                             unity_4LightAtten0,
                                                             wPos,N);
                  return  color1+UNITY_LIGHTMODEL_AMBIENT;
             }

             ENDCG
         }
     }
}
