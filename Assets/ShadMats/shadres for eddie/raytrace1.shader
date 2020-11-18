// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/raytrace1" {
  Properties {
  

    _NumberSteps( "Number Steps", Int ) = 10
    _StepSize( "Step Size", Float ) = .3
    _NoiseSize( "Noise Size" , Float ) = 100.
    _HueSize( "Hue Size" , Float ) = .08
    _BaseHue( "Base Hue" , Float ) = .9
    _NoiseSpeed( "Noise Speed" , Float ) = .8


            _MainTex ("Texture", 2D) = "white" {}
        _TimeInClip("time in clip", float ) = .5


  }
  SubShader {
    //Tags { "RenderType"="Transparent" "Queue" = "Transparent" }

    Tags { "RenderType"="Opaque" }
    LOD 200
    Pass {
      //Blend SrcAlpha OneMinusSrcAlpha // Alpha blending


      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
      // Use shader model 3.0 target, to get nicer looking lighting
      #pragma target 4.5

      #include "UnityCG.cginc"
      
      #pragma exclude_renderers d3d11_9x
      
   //   #define UNITY_PASS_FORWARDBASE
   //         #define SHOULD_SAMPLE_SH ( defined (LIGHTMAP_OFF) && defined(DYNAMICLIGHTMAP_OFF) )
   //         #define _GLOSSYENV 1
   //         #include "UnityCG.cginc"
   //         #include "AutoLight.cginc"
   //         #include "Lighting.cginc"
   //         #include "UnityPBSLighting.cginc"
   //         #include "UnityStandardBRDF.cginc"
   //         #pragma multi_compile_fwdbase_fullshadows
   //         #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
   //         #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
   //         #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
   //         #pragma multi_compile_fog
   //         #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
   //         #pragma target 3.0
//
//
      uniform int _NumberSteps;
      uniform float _StepSize;
      uniform float _NoiseSize;
      uniform float _NoiseSpeed;
      uniform float _HueSize;
      uniform float _BaseHue;
      


        struct VertexIn
      {
         float4 position  : POSITION; 
         float3 normal    : NORMAL; 
         float4 texcoord  : TEXCOORD0; 
         float4 tangent   : TANGENT;
      };

      struct VertexOut {
          float4 pos    : POSITION; 
          float3 normal : NORMAL; 
          float4 uv     : TEXCOORD0; 
          float3 ro     : TEXCOORD2;
          float3 rd     : TEXCOORD3;
      };
        

           sampler2D _MainTex;
            float4 _MainTex_ST;

            float _TimeInClip;

float4x4 rotateX(float angle){
    
	angle = -angle/180.0*3.1415926536;
    float c = cos(angle);
    float s = sin(angle);
	return float4x4(1.0, 0.0, 0.0, 0.0, 0.0, c, -s, 0.0, 0.0, s, c, 0.0, 0.0, 0.0, 0.0, 1.0);
    
}

float4x4 rotateY(float angle){
    
	angle = -angle/180.0*3.1415926536;
    float c = cos(angle);
    float s = sin(angle);
	return float4x4(c, 0.0, s, 0.0, 0.0, 1.0, 0.0, 0.0, -s, 0.0, c, 0.0, 0.0, 0.0, 0.0, 1.0);
    
}

float4x4 rotateZ(float angle){
    
	angle = -angle/180.0*3.1415926536;
    float c = cos(angle);
    float s = sin(angle);
	return float4x4(c, -s, 0.0, 0.0, s, c, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0);
    
}
float4x4 translate(float3 t){
    
    float4 row1 = float4(1.0, 0.0, 0.0, -t.x);
    float4 row2 = float4(0.0, 1.0, 0.0, -t.y);
    float4 row3 = float4(0.0, 0.0, 1.0, -t.z);
    float4 row4 = float4(0.0, 0.0, 0.0, 1.);
	return float4x4(row1,row2,row3,row4);
    
}


float sdCappedCylinder( float3 p, float2 h )
{
  float2 d = abs(float2(length(p.xz),p.y)) - h;
  return min(max(d.x,d.y),0.0) + length(max(d,0.0));
}


float sdSphere( float3 p, float r )
{
  return length( p ) - r;
}


float2 smoothU( float2 d1, float2 d2, float k)
{
    float a = d1.x;
    float b = d2.x;
    float h = clamp(0.5+0.5*(b-a)/k, 0.0, 1.0);
    return float2( lerp(b, a, h) - k*h*(1.0-h), lerp(d2.y, d1.y, pow(h, 2.0)));
}

float2 opU( float2 d1, float2 d2 ){
 return d1.x < d2.x ? d1 : d2;   
}
// Euler angles rotation matrix
float4x4 Euler3x3(float3 v)
{
    float sx, cx;
    float sy, cy;
    float sz, cz;

    sincos(v.x, sx, cx);
    sincos(v.y, sy, cy);
    sincos(v.z, sz, cz);

    float4 row1 = float4(sx*sy*sz + cy*cz, sx*sy*cz - cy*sz, cx*sy,0);
    float4 row3 = float4(sx*cy*sz - sy*cz, sx*cy*cz + sy*sz, cx*cy,0);
    float4 row2 = float4(cx*sz, cx*cz, -sx,0);
    float4 row4 = float4(0, 0, 0,1);

    return float4x4(row1, row2, row3, row4);
}



//--------------------------------
// Modelling 
//--------------------------------
float2 map( float3 pos ){  
    
    
    float branchSize = .8;
    float reductionFactor = .6;// +  .2 * sin( _Time.y * 1.73 );
    float trunkSize = .2 +  1.01 * sin( _Time.y * 3.27 );
    float bs = branchSize;
    float rot = 40. + 20. * sin( _Time.y * .4 );
    const int numSteps =3;
    //pos += float3( 0. , branchSize , 0. );

   
    float4 p = float4( pos , 1. );
    float4x4 m;
    
   	//float2 res = float2( (abs(sin( pos.x * pos.y * pos.z  * 10.)) * 1.9 ) + length( pos ) - 1., 0.0 );
  
    float2 res = float2( 10000. ,1.);
    
    for( int i = 0; i <numSteps; i ++ ){
        bs *= reductionFactor;

      m = mul(Euler3x3( normalize(float3( sin(_Time.y),1,2))) , translate(float3( bs, 0.  , 0.) ));//mul(Euler3x3( normalize(float3( 3,1,2))) , translate(float3( 10., 0.  , 0.) * 5.));//translate(float3( bs, 0.  , 0.) * 1.)  * rotateY(rot* sin( _Time.y * .53 )) * rotateX(rot* sin( _Time.y * .37 )) * rotateZ(rot * sin( _Time.y * .2 ));    
      p.x = abs(p.x) - bs / 2.;
      p.z = abs(p.z) - bs / 2.; 
      p.y = abs(p.y) - bs / 2.;   

       p = mul( m,p); 

        //res = smoothU( res , float2( sdCappedCylinder( p.xyz , float2( trunkSize * bs , bs )),1.) , .1);
        //res = smoothU( res , float2( sdSphere( p.xyz ,  bs * ( 1. + .4 * sin( _Time.y * float( i )/ 10.)) ),float(i)/float(numSteps)) , .1 - .1 * float(i)/float(numSteps) );
        //res = smoothU( res , float2( sdSphere( p.xyz ,  1. ) , 1) , .1);
        //res = opU( res , float2( sdSphere( p.xyz ,  bs * ( 1. + .4 * sin( _Time.y * float( i )/ 10.)) ),float(i)/float(numSteps)) );

float v = sdSphere( p.xyz , bs );

float3 eps = float3(.01,0,0);
      float3 nor = normalize( float3(
sdSphere( p.xyz + eps.xyy , bs )-v,
sdSphere( p.xyz + eps.yxy , bs )-v,
sdSphere( p.xyz + eps.yyx , bs )-v

      ));

        res = opU( res , float2( sdSphere( p.xyz , bs ),float(i)/float(numSteps)) );
         fixed4 col = tex2D(_MainTex, float2(abs(dot(nor, float3(1,1,0))  ) * .1+ .4 * float(i)/float(numSteps), _TimeInClip));
        res.x += .01 * col.x;
       
        //res = opU( res , float2( sdSphere( p.xyz , trunkSize * bs * 10. ),1. ));




    }

   	return res;
    
}



  /*    float2 map( in float3 pos ){
              fixed4 col = tex2D(_MainTex, float2(pow(abs(pos.x * .3) ,1.5), _TimeInClip));
             
	    return float2( length( pos ) - 1   + col.x * .2, col.x ); 
	 
	  }*/

     float3 calcNormal( in float3 pos ){
        	float3 eps = float3( 0.001, 0.0, 0.0 );
        	float3 nor = float3(
        	    map(pos+eps.xyy).x - map(pos-eps.xyy).x,
        	    map(pos+eps.yxy).x - map(pos-eps.yxy).x,
        	    map(pos+eps.yyx).x - map(pos-eps.yyx).x );
        	return normalize(nor);
        
        
        }
            
       
    const float MAX_TRACE_DISTANCE = 30.0;             // max trace distance
    const float INTERSECTION_PRECISION = 0.0001;        // precision of the intersection
    const int NUM_OF_TRACE_STEPS = 200;

      float2 calcIntersection( in float3 ro , in float3 rd ){     
            
                
                float h =  .001 * 2;
                float t = 0.0;
                float res = -1.0;
                float id = -1.0;


                for( int i=0; i< 2; i++ ){
                    
                    if( h < 0.001 || t > 10.0 ) break;
            
                    float3 pos = ro + rd*t;
                    float2 m = map( pos );
                    
                    h = m.x;
                    
                    t += h;
                    
                    id = m.y;
                    
                }
            
            
                if( t <  10. ){ res = t; }
                if( t >  10. ){ id = -1.0; }
                
                return float2( res , id );
                
            
            }
            
    

      VertexOut vert(VertexIn v) {
        
        VertexOut o;

        o.normal = v.normal;
        
        o.uv = v.texcoord;
  
        // Getting the position for actual position
        o.pos = UnityObjectToClipPos(  v.position );
     
        float3 mPos = mul( unity_ObjectToWorld , v.position );

        o.ro = mPos;//v.position;
        o.rd =-normalize(_WorldSpaceCameraPos - mPos );// mul( unity_WorldToObject , float4( -normalize(_WorldSpaceCameraPos - mPos ) , 0. )); 

        return o;

      }


     // Fragment Shader
      fixed4 frag(VertexOut i) : COLOR {

        float3 ro = i.ro;
        float3 rd = i.rd;

        float3 col = float3( 0.0 , 0.0 , 0.0 );
		float2 res = calcIntersection( ro , rd );
		
		col= 0;//float3( ro - rd );
		if( res.y >= 0. ){
			float3 pos = ro + rd * res.x;
			float3 nor = calcNormal( pos );
			col = nor * .5 + .5;
      
       col = tex2D(_MainTex, float2(abs(dot(nor, float3(1,1,0))) * .1 + .4 * res.y, _TimeInClip)).xyz;
      //col = res.y;
			//col = float3( 1. , 0. , 0. );
			
		}
 
		//col = float3( 1. , 1. , 1. );

        fixed4 color;
        color = fixed4( col , 1. );
        return color;
      }

      ENDCG
    }
  }
  FallBack "Diffuse"
}