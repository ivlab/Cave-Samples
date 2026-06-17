Shader "Custom/SpotlightHiding"
{
    Properties
    {
        _BaseMap ("Graffiti Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)

        _LightPos ("Light Position", Vector) = (0,0,0,0)
        _LightDir ("Light Direction", Vector) = (0,0,1,0)
        _SpotAngle ("Spot Angle", Float) = 30
        _Range ("Range", Float) = 10
        _Softness ("Edge Softness", Float) = 0.15
        _HideStrength ("Hide Strength", Range(0,1)) = 1
    }

    SubShader
    {
        Tags
        {
            "RenderType"="Transparent"
            "Queue"="Transparent"
            // "RenderPipeline"="UniversalPipeline"
        }

        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off
        Cull Off

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            // #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "UnityCG.cginc"
            
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;

            float4 _LightPos;
            float4 _LightDir;
            float _SpotAngle;
            float _Range;
            float _Softness;
            float _HideStrength;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
            };

            v2f vert(appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 tex = tex2D(_MainTex, i.uv) * _Color;

                float3 lightPos = _LightPos.xyz;
                float3 lightDir = normalize(_LightDir.xyz);

                float3 toPixel = i.worldPos - lightPos;
                float dist = length(toPixel);
                float3 dirToPixel = normalize(toPixel);

                float angleDot = dot(dirToPixel, lightDir);

                float outerCos = cos(radians(_SpotAngle * 0.5));
                float innerCos = cos(radians((_SpotAngle * 0.5) * (1.0 - _Softness)));

                float angleMask = smoothstep(outerCos, innerCos, angleDot);
                float rangeMask = 1.0 - smoothstep(_Range * 0.9, _Range, dist);

                float hideMask = angleMask * rangeMask;

                tex.a *= lerp(1.0, 1.0 - hideMask, _HideStrength);

                return tex;
            }

            ENDCG
        }
    }
}
