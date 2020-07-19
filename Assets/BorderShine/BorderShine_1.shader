// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "sbin/BorderShine_1" {
	 Properties{
	     _MainColor("MainColor",color)=(1,1,1,1)
	     _Scale("Scale",Range(1,8))=2
		 _Outer("Outer",Range(0,1))=0.2
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
			     v.vertex.xyz+=v.normal*0.2f;
		          v2f o;
			      o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			      o.vertex=v.vertex;
			      o.normal=v.normal;
			      return o;
		     }

		     float _Scale;
			 fixed4 _MainColor;
		     fixed4 frag(v2f IN):COLOR
	    	 {
		         float3 N=normalize( UnityObjectToWorldNormal(IN.normal));
		    	 float3 worldPos=mul(unity_ObjectToWorld,IN.vertex);
		    	 float3 v=normalize( _WorldSpaceCameraPos-worldPos);
		    	// float3 V=normalize( WorldSpaceViewDir(float4(IN.vertex,0))) ;
		    	 float bri=  saturate(dot(N,v));
				// bri=(bri+1)/2;
		    	 //bri=pow(bri,_Scale);
				 _MainColor.a*=bri;
				 //_MainColor=fixed4(bri,bri,bri,1);
		        // return fixed4(1,1,1,1)*bri;
				return _MainColor;
		     }
		 
		ENDCG
		}

		 pass{
		     BLENDOP revsub
	         //blend zero one
			 blend DstAlpha one
			 ZWrite off
		     CGPROGRAM		 	 
		    #pragma vertex vert
		    #pragma fragment frag
		    #include "UnityCG.cginc"

		    struct v2f {
			    float4 pos:POSITION;
			   
		    };
		 
		     v2f vert(appdata_base v){
			    
		          v2f o;
			      o.pos=mul(UNITY_MATRIX_MVP,v.vertex);			    
			      return o;
		     }

		     float _Scale;
			 fixed4 _MainColor;
		     fixed4 frag(v2f IN):COLOR
	    	 {
		         
		         return fixed4(1,1,1,1);
		     }
		 
		ENDCG
		}

		  pass{
	         //blend zero one
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
			     //v.vertex.xyz+=v.normal*0.2;
		          v2f o;
			      o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			      o.vertex=v.vertex;
			      o.normal=v.normal;
			      return o;
		     }

		     float _Scale;
		     fixed4 frag(v2f IN):COLOR
	    	 {
		         float3 N=normalize( UnityObjectToWorldNormal(IN.normal));
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
