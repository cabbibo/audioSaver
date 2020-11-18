Shader "Unlit/CurrentFrame"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _TimeInClip("time in clip", float ) = .5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

       sampler2D _MainTex;
            float4 _MainTex_ST;
     
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float _TimeInClip;
            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, float2(pow(i.uv.x * .7 ,1.5), _TimeInClip));// * 10.);// * 1000000.;
                fixed4 col2 = tex2D(_MainTex, float2(pow(i.uv.x * .7,1.5), _TimeInClip-.01));// * 10.);// * 1000000.;
               
                
                

                col = lerp( col2 , col , .8);
                //col = exp(col*2-2);
                return col;
            }
            ENDCG
        }
    }
}
