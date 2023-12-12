Shader "Explorer/Mandelbrot"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Area( "Area", vector) = (0, 0, 0, 0)
        _Ite("Iterations", range(5, 1000)) = 0
        _Inf("Influence", float) = 0
        _Other( "Other", vector) = (0, 0, 0, 0)
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            static const float pi = 3.14159265f;

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 _Area;
            sampler2D _MainTex;
            float _Ite, _Inf;
            float4 _Other;

            fixed4 frag (v2f i) : SV_Target
            {
                bool mandel = true;
                float2 c = _Area.xy + (i.uv-.5)*_Area.zw;
                float2 z = mandel ? _Other.xy: c;
                float2 zold;
                float iter;
                float maxi = _Ite;
                float r = 20;
                for(iter = 0; iter < maxi; iter++){
                    zold = z;
                    z = mandel ? float2(z.x*z.x-z.y*z.y, 2*z.x*z.y) + c: float2(z.x*z.x-z.y*z.y, 2*z.x*z.y) + _Other.xy;
                    if(dot(z, z) > r * r) break;
                }
                if(iter + 0.5 > maxi) return 0;
                float dist = length(z);
                float fracIter = log2(log(dist) / log(r)); //froces linearizalation  as log_z(z_n)~2^n
                iter -= fracIter;
                float curr = maxi - iter;
                curr *= 100;
                curr += _Inf;
                float3 rainbow = 0.5 * sin(float3(pi/46, pi/23, pi/33) * curr) + 0.5;
                float3 gray = 0.5 * sin(pi / 30 * curr) + 0.5;
                float3 water = 0.1 * sin(float3(pi/30, pi/30, pi/30) * curr) + float3(0.05, 0.2, 0.6);
                return float4(rainbow, 1);
                //return float4(rainbow, 1) * smoothstep(3, 0, fracIter);
            }
            ENDCG
        }
    }
}
