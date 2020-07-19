 
Shader "Custom/Frag_Color" {
     Properties{
         _mainColor("mainColor",color)=(1,1,1,1)
         _secondColor("secondColor",color)=(1,1,1,1)
         _Center("center",Range(-0.7,0.7))=0
         _R("R",Range(0,0.5))=0.2
     }
     SubShader{
         pass{
          
             CGPROGRAM

             #pragma vertex  vert
             #pragma fragment frag
             #include "unitycg.cginc"
             #include "lighting.cginc"
             fixed4 _mainColor;
             fixed4 _secondColor;
             float _Center;
             float _R;
             struct v2f{
                 float4 pos: POSITION;
                 float y:COLOR;
             };

             v2f vert(appdata_base v){
                 v2f o;
                 o.pos=mul(UNITY_MATRIX_MVP,v.vertex);      
                 o.y=v.vertex.y;
                 return o;
             }

             fixed4 frag(v2f IN):COLOR{
                  //if(IN.y>_Center+_R){
                  //    return _mainColor;
                  //}else if( IN.y>_Center&&IN.y<_Center+_R ) {
                  //    float d=IN.y-_Center; //顶点与半径的位置关系
                  //   // d=(1-d/_R)-0.5;
                  //    d=(d/_R)/2+0.5;//确保得数在0.5-1
                  //    return lerp(_secondColor,_mainColor,d);
                  //}
                  //else if(IN.y<_Center&&IN.y>_Center-_R){
                  //  float d=_Center-IN.y; //顶点与半径的位置关系                    
                  //    d=(d/_R)/2+0.5;
                  //    return lerp(_mainColor,_secondColor,d);
                       
                  //}
                  ////else if(IN.y<_Center-_R) {
                  ////    return _secondColor;
                  ////}
                  //else{
                  // return _secondColor;
                  //}
                  float d=IN.y-_Center;
                  float s=abs(d);//得到标明此顶点 正负得标志
                  //得到 分界距离
                  
                  float  f= saturate( s/_R);// 分解距离 除以半径
                   d=d*f;//按正负标记给予符号
                   d=d/2+0.5;

                  //float d=IN.y-_Center;// 以ceter为中心，将顶点上下分层 
                  //d=d/abs(d);//上层得到 正1  下层得到负1
                  //d=d/2+0.5;//将得数迁移到 0-1
                  return lerp(_mainColor,_secondColor,d);
             }

             ENDCG
         }
     }
}
