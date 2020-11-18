// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.17 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.17;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,ofsf:0,ofsu:0,f2p0:False;n:type:ShaderForge.SFN_Final,id:2275,x:33918,y:33092,varname:node_2275,prsc:2|diff-5305-OUT,voffset-6598-XYZ;n:type:ShaderForge.SFN_FragmentPosition,id:2363,x:30945,y:33768,varname:node_2363,prsc:2;n:type:ShaderForge.SFN_ObjectPosition,id:7626,x:30945,y:33891,varname:node_7626,prsc:2;n:type:ShaderForge.SFN_Subtract,id:2461,x:31151,y:33768,varname:node_2461,prsc:2|A-2363-XYZ,B-7626-XYZ;n:type:ShaderForge.SFN_Time,id:6601,x:31436,y:33555,varname:node_6601,prsc:2;n:type:ShaderForge.SFN_Transform,id:5466,x:31313,y:33768,varname:node_5466,prsc:2,tffrom:0,tfto:1|IN-2461-OUT;n:type:ShaderForge.SFN_ComponentMask,id:2573,x:31480,y:33768,varname:node_2573,prsc:2,cc1:0,cc2:-1,cc3:-1,cc4:-1|IN-5466-XYZ;n:type:ShaderForge.SFN_Multiply,id:8938,x:31691,y:33960,varname:node_8938,prsc:2|A-2573-OUT,B-1099-OUT;n:type:ShaderForge.SFN_Vector1,id:1099,x:31371,y:33994,cmnt:amount by which is scaled up,varname:node_1099,prsc:2,v1:2.2;n:type:ShaderForge.SFN_Sin,id:8683,x:32201,y:33940,varname:node_8683,prsc:2|IN-906-OUT;n:type:ShaderForge.SFN_Sin,id:2718,x:31865,y:33563,varname:node_2718,prsc:2|IN-6601-T;n:type:ShaderForge.SFN_Multiply,id:5264,x:32217,y:33709,varname:node_5264,prsc:2|A-2718-OUT,B-8683-OUT;n:type:ShaderForge.SFN_NormalVector,id:3170,x:34254,y:32787,prsc:2,pt:False;n:type:ShaderForge.SFN_Multiply,id:6098,x:34467,y:32787,varname:node_6098,prsc:2|A-3170-OUT,B-9763-OUT;n:type:ShaderForge.SFN_Vector1,id:9763,x:34467,y:32957,varname:node_9763,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Add,id:5305,x:34642,y:32787,varname:node_5305,prsc:2|A-6098-OUT,B-9763-OUT;n:type:ShaderForge.SFN_Multiply,id:8739,x:32503,y:33729,varname:node_8739,prsc:2|A-5264-OUT,B-5423-OUT;n:type:ShaderForge.SFN_Append,id:262,x:32732,y:33611,varname:node_262,prsc:2|A-9815-OUT,B-8739-OUT,C-9815-OUT;n:type:ShaderForge.SFN_Vector1,id:9815,x:32349,y:33234,varname:node_9815,prsc:2,v1:0;n:type:ShaderForge.SFN_Transform,id:6598,x:33097,y:33901,varname:node_6598,prsc:2,tffrom:1,tfto:0|IN-5087-OUT;n:type:ShaderForge.SFN_Vector1,id:5423,x:32577,y:33895,varname:node_5423,prsc:2,v1:1;n:type:ShaderForge.SFN_Abs,id:8161,x:31860,y:33960,varname:node_8161,prsc:2|IN-8938-OUT;n:type:ShaderForge.SFN_Append,id:6722,x:32732,y:33460,varname:node_6722,prsc:2|A-9815-OUT,B-2718-OUT,C-9815-OUT;n:type:ShaderForge.SFN_Add,id:5087,x:33046,y:33643,varname:node_5087,prsc:2|A-7030-OUT,B-262-OUT;n:type:ShaderForge.SFN_Negate,id:7508,x:33370,y:33231,varname:node_7508,prsc:2|IN-7030-OUT;n:type:ShaderForge.SFN_Multiply,id:7030,x:33002,y:33385,varname:node_7030,prsc:2|A-6214-OUT,B-6722-OUT;n:type:ShaderForge.SFN_ValueProperty,id:6214,x:32388,y:32987,ptovrint:False,ptlb:node_6214,ptin:_node_6214,varname:node_6214,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.4;n:type:ShaderForge.SFN_Multiply,id:906,x:32041,y:33940,varname:node_906,prsc:2|A-5407-OUT,B-8161-OUT;n:type:ShaderForge.SFN_Add,id:5407,x:32103,y:33383,varname:node_5407,prsc:2|A-5455-OUT,B-973-OUT;n:type:ShaderForge.SFN_ValueProperty,id:973,x:31822,y:33387,ptovrint:False,ptlb:node_973,ptin:_node_973,varname:node_973,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:5455,x:31942,y:33251,varname:node_5455,prsc:2|A-5360-OUT,B-2718-OUT;n:type:ShaderForge.SFN_ValueProperty,id:5360,x:31596,y:33452,ptovrint:False,ptlb:node_5360,ptin:_node_5360,varname:node_5360,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.3;proporder:6214-973-5360;pass:END;sub:END;*/

Shader "Custom/vertShader" {
    Properties {
        _node_6214 ("node_6214", Float ) = 0.4
        _node_973 ("node_973", Float ) = 1
        _node_5360 ("node_5360", Float ) = 0.3
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        LOD 200
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform float4 _TimeEditor;
            uniform float _node_6214;
            uniform float _node_973;
            uniform float _node_5360;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 posWorld : TEXCOORD0;
                float3 normalDir : TEXCOORD1;
                LIGHTING_COORDS(2,3)
                UNITY_FOG_COORDS(4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                float node_9815 = 0.0;
                float4 node_6601 = _Time + _TimeEditor;
                float node_2718 = sin(node_6601.g);
                float3 node_7030 = (_node_6214*float3(node_9815,node_2718,node_9815));
                v.vertex.xyz += mul( unity_ObjectToWorld, float4((node_7030+float3(node_9815,((node_2718*sin((((_node_5360*node_2718)+_node_973)*abs((mul( unity_WorldToObject, float4((mul(unity_ObjectToWorld, v.vertex).rgb-objPos.rgb),0) ).xyz.rgb.r*2.2)))))*1.0),node_9815)),0) ).xyz.rgb;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex);
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                i.normalDir = normalize(i.normalDir);
/////// Vectors:
                float3 normalDirection = i.normalDir;
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light
                float node_9763 = 0.5;
                float3 diffuseColor = ((i.normalDir*node_9763)+node_9763);
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_fog
            #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform float4 _TimeEditor;
            uniform float _node_6214;
            uniform float _node_973;
            uniform float _node_5360;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 posWorld : TEXCOORD0;
                float3 normalDir : TEXCOORD1;
                LIGHTING_COORDS(2,3)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                float node_9815 = 0.0;
                float4 node_6601 = _Time + _TimeEditor;
                float node_2718 = sin(node_6601.g);
                float3 node_7030 = (_node_6214*float3(node_9815,node_2718,node_9815));
                v.vertex.xyz += mul( unity_ObjectToWorld, float4((node_7030+float3(node_9815,((node_2718*sin((((_node_5360*node_2718)+_node_973)*abs((mul( unity_WorldToObject, float4((mul(unity_ObjectToWorld, v.vertex).rgb-objPos.rgb),0) ).xyz.rgb.r*2.2)))))*1.0),node_9815)),0) ).xyz.rgb;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                i.normalDir = normalize(i.normalDir);
/////// Vectors:
                float3 normalDirection = i.normalDir;
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float node_9763 = 0.5;
                float3 diffuseColor = ((i.normalDir*node_9763)+node_9763);
                float3 diffuse = directDiffuse * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse;
                return fixed4(finalColor * 1,0);
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_fog
            #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform float _node_6214;
            uniform float _node_973;
            uniform float _node_5360;
            struct VertexInput {
                float4 vertex : POSITION;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float4 posWorld : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                float node_9815 = 0.0;
                float4 node_6601 = _Time + _TimeEditor;
                float node_2718 = sin(node_6601.g);
                float3 node_7030 = (_node_6214*float3(node_9815,node_2718,node_9815));
                v.vertex.xyz += mul( unity_ObjectToWorld, float4((node_7030+float3(node_9815,((node_2718*sin((((_node_5360*node_2718)+_node_973)*abs((mul( unity_WorldToObject, float4((mul(unity_ObjectToWorld, v.vertex).rgb-objPos.rgb),0) ).xyz.rgb.r*2.2)))))*1.0),node_9815)),0) ).xyz.rgb;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex);
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
/////// Vectors:
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
