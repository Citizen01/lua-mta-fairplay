texture gTexture;
technique fallback
{
    pass P0
    {
        Texture[0] = gTexture;
    }
}