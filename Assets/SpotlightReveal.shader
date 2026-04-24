Shader "Custom/SpotlightReveal"
{
    Properties
    {
        _BaseMap ("Graffiti Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)

        _LightPos ("Light Position", Vector) = (0,0,0,0)
        _LightDir ("Light Direction", Vector) = (0,0,1,0)
        _SpotAngle ("Spot Angle", Float) = 30
        _Range ("Range", Float) = 10
        _Softness ("Edge Softness", Float) = 0.1
    }

    SubShader
    {
        Tags
        {
            "RenderType"="Transparent"
            "Queue"="Transparent"
            "RenderPipeline"="UniversalPipeline"
        }

        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off
        Cull Off

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);

            CBUFFER_START(UnityPerMaterial)
                float4 _BaseMap_ST;
                float4 _Color;

                float4 _LightPos;
                float4 _LightDir;
                float _SpotAngle;
                float _Range;
                float _Softness;
            CBUFFER_END

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 positionWS : TEXCOORD1;
            };

            Varyings vert(Attributes IN)
            {
                Varyings OUT;

                VertexPositionInputs positionInputs = GetVertexPositionInputs(IN.positionOS.xyz);

                OUT.positionHCS = positionInputs.positionCS;
                OUT.positionWS = positionInputs.positionWS;
                OUT.uv = TRANSFORM_TEX(IN.uv, _BaseMap);

                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half4 tex = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv) * _Color;

                float3 lightPos = _LightPos.xyz;
                float3 lightDir = normalize(_LightDir.xyz);

                float3 toPixel = IN.positionWS - lightPos;
                float dist = length(toPixel);
                float3 dirToPixel = normalize(toPixel);

                float angleDot = dot(dirToPixel, lightDir);

                float outerCos = cos(radians(_SpotAngle * 0.5));
                float innerCos = cos(radians((_SpotAngle * 0.5) * (1.0 - _Softness)));

                float angleMask = smoothstep(outerCos, innerCos, angleDot);
                float rangeMask = 1.0 - smoothstep(_Range * 0.9, _Range, dist);

                float revealMask = angleMask * rangeMask;

                tex.a *= revealMask;

                return tex;
            }

            ENDHLSL
        }
    }
}