// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/corona" {
	Properties {

    _NumberSteps( "Number Steps", Int ) = 30
    _StepSize( "Step Size", Float ) = .01
    _NoiseSize( "Noise Size" , Float ) = 100.
    _NoiseSpeed( "Noise Speed" , Float ) = 2.
    _HueSize( "Hue Size" , Float ) = .08
    _BaseHue( "Base Hue" , Float ) = .9



  }
  SubShader {
    Tags { "RenderType"="Transparent" "Queue" = "Transparent" }
    LOD 200
    ZWrite Off
    Pass {
      Blend SrcAlpha OneMinusSrcAlpha // Alpha blending
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
      // Use shader model 3.0 target, to get nicer looking lighting
      #pragma target 3.0

      #include "UnityCG.cginc"

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

      

      float3 hsv(float h, float s, float v){
        return lerp( float3( 1.0 ), clamp(( abs( frac(h + float3( 3.0, 2.0, 1.0 ) / 3.0 )
        					 * 6.0 - 3.0 ) - 1.0 ), 0.0, 1.0 ), s ) * v;
      }


			// Taken from https://www.shadertoy.com/view/4ts3z2
			// By NIMITZ  (twitter: @stormoid)
			// good god that dudes a genius...

			float tri( float x ){ 
			  return abs( frac(x) - .5 );
			}

			float3 tri3( float3 p ){
			 
			  return float3( 
			      tri( p.z + tri( p.y * 1. ) ), 
			      tri( p.z + tri( p.x * 1. ) ), 
			      tri( p.y + tri( p.x * 1. ) )
			  );

			}
			                                 

			float triNoise3D( float3 p, float spd , float time){
			  
			  float z  = 1.4;
				float rz =  0.;
			  float3  bp =   p;

				for( float i = 0.; i <= 3.; i++ ){
			   
			    float3 dg = tri3( bp * 2. );
			    p += ( dg + time * .1 * spd );

			    bp *= 1.8;
					z  *= 1.5;
					p  *= 1.2; 
			      
			    float t = tri( p.z + tri( p.x + tri( p.y )));
			    rz += t / z;
			    bp += 0.14;

				}

				return rz;

			}

    

      VertexOut vert(VertexIn v) {
        
        VertexOut o;

        o.normal = v.normal;
        
        o.uv = v.texcoord;
  
        // Getting the position for actual position
        o.pos = UnityObjectToClipPos(  v.position );
     
        float3 mPos = mul( unity_ObjectToWorld , v.position );

        o.ro = v.position;
        o.rd = mul( unity_WorldToObject , float4( -normalize(_WorldSpaceCameraPos - mPos ) , 0. )); 

        return o;
        
      }

      // Fragment Shader

      fixed4 frag(VertexOut i) : COLOR {

        float3 ro = i.ro;
        float3 rd = i.rd;

        float3 center = float3(0.);
         
        float3 col = float3( 0.0 , 0. , 0. );

        float3 p;

        float acc = 0.;
        float density = 0.;
        
        for( int i = 0; i < _NumberSteps; i++ ){

          p = ro + rd * float( i ) * _StepSize / _NumberSteps;

          /* MAGIC */ 

          float dist = length( p - center );
          float stripeVal = pow((.1/dist),2.)  * _NoiseSize;
          float val = dist - .2;
          val = max( 0. , val);
          float corona = 10. / val;
          float fogVal = triNoise3D( stripeVal * p * dist , 10. , _Time * _NoiseSpeed );//length( sin( p * 10.));
          acc += fogVal;
          col += hsv( acc * _HueSize + _BaseHue , 1. , 1. ) ;

          float fallOff = pow( dist * 3. , 2. ) - pow( dist * 2.7 , 3. );
          density += fogVal * fogVal * 20. * fallOff *fogVal*fogVal  * val * 10.;

        }

        col /= _NumberSteps;

		    fixed4 color;
        color = fixed4( col , density );
        return color;
      }

      ENDCG
    }
  }
  FallBack "Diffuse"
}

