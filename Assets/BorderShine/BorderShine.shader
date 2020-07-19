// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "sbin/BorderShine" {
	 Properties{
	     _Scale("Scale",Range(1,8))=2
	 }

	SubShader {
	   tags{"queue"="transparent"}
	    pass{
	         blend SrcAlpha OneMinusSrcAlpha
			 ZWrite off
		     CGPROGRAM		 	 
		    #pragma vertex vert
		    #pragma fragment frag
		    #include "UnityCG.cginc"

		    struct v2f {
			    float4 pos:POSITION;
			    float3 normal:NORMAL;
			    float3 vertex:TEXCOORD;
		    };
		 
		     v2f vert(appdata_base v){
		          v2f o;
			      o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			      o.vertex=v.vertex;
			      o.normal=v.normal;
			      return o;
		     }

		     float _Scale;
		     fixed4 frag(v2f IN):COLOR
	    	 {
		         float3 N= UnityObjectToWorldNormal(IN.normal);
		    	 float3 worldPos=mul(unity_ObjectToWorld,IN.vertex);
		    	 float3 v=normalize( _WorldSpaceCameraPos-worldPos);
		    	// float3 V=normalize( WorldSpaceViewDir(float4(IN.vertex,0))) ;
		    	 float bri= 1.0-saturate(dot(N,v));
		    	 bri=pow(bri,_Scale);
		         return fixed4(1,1,1,1)*bri;
		 }
		 
		ENDCG
		}
	}
	 
}
