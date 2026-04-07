float bayer4x4(ivec2 pos)
{
    int x = pos.x & 3;
    int y = pos.y & 3;
    int idx = y * 4 + x;
    float table[16];
    table[0]  =  0.0; table[1]  =  8.0; table[2]  =  2.0; table[3]  = 10.0;
    table[4]  = 12.0; table[5]  =  4.0; table[6]  = 14.0; table[7]  =  6.0;
    table[8]  =  3.0; table[9]  = 11.0; table[10] =  1.0; table[11] =  9.0;
    table[12] = 15.0; table[13] =  7.0; table[14] = 13.0; table[15] =  5.0;
    return table[idx] / 16.0;
}

vec2 snapUV(vec2 uv, float resolution, vec2 texSize)
{
    float aspect = texSize.x / texSize.y;
    vec2  grid   = vec2(resolution * aspect, resolution);
    return floor(uv * grid + 0.5) / grid;
}

vec2 affineDistort(vec2 uv, float strength)
{
    vec2  delta = uv - vec2(0.5);
    float dist  = length(delta);
    float amp   = 0.003 * strength;
    float freq  = 5.5;
    float wx = sin(delta.y * freq * 3.14159) * amp * dist * 2.0;
    float wy = sin(delta.x * freq * 3.14159) * amp * dist * 2.0;
    return uv + vec2(wx, wy);
}

vec3 reduceColorDepth(vec3 color, float steps)
{
    return floor(color * steps + 0.5) / steps;
}

void main()
{
    ivec2 texSizeI = textureSize(InputTexture, 0);
    vec2  texSize  = vec2(texSizeI);

    vec2 uv = TexCoord;

    bool affineEnable = (ps1Flags & 1)  != 0;
    bool snapEnable   = (ps1Flags & 2)  != 0;
    bool ditherEnable = (ps1Flags & 4)  != 0;
    int  colorDepth   = (ps1Flags >> 4) & 0xF;

    int   snapIdx   = (ps1Params)      & 0xFF;
    float affineStr = float((ps1Params >> 8) & 0xFF) / 50.0;

    float snapTable[8];
    snapTable[0] = 480.0;
    snapTable[1] = 360.0;
    snapTable[2] = 320.0;
    snapTable[3] = 240.0;
    snapTable[4] = 160.0;
    snapTable[5] = 120.0;
    snapTable[6] =  80.0;
    snapTable[7] =  60.0;
    float snapRes = snapTable[clamp(snapIdx, 0, 7)];

    if (snapEnable)
    {
        uv = snapUV(uv, snapRes, texSize);
    }

    if (affineEnable && affineStr > 0.0)
    {
        uv = affineDistort(uv, affineStr);
    }

    uv = clamp(uv, vec2(0.0), vec2(1.0));

    vec4 color = texture(InputTexture, uv);

    if (ditherEnable)
    {
        ivec2 pixelPos = ivec2(TexCoord * texSize);
        float dither   = bayer4x4(pixelPos) - 0.5;
        color.rgb     += vec3(dither * 0.04);
    }

    if (colorDepth > 0)
    {
        float steps = float(64 >> (colorDepth - 1));
        color.rgb = reduceColorDepth(color.rgb, steps);
    }

    FragColor = color;
}
