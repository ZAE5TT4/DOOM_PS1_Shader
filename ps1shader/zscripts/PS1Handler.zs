class PS1Handler : EventHandler
{
    override void RenderOverlay(RenderEvent e)
    {
        int pNum = consoleplayer;

        if (gamestate != GS_LEVEL)
        {
            DisableShader();
            return;
        }

        if (pNum < 0 || pNum >= MAXPLAYERS || !PlayerInGame[pNum])
        {
            DisableShader();
            return;
        }

        PlayerInfo p = players[pNum];
        if (p == null || p.mo == null)
        {
            DisableShader();
            return;
        }

        if (!PS1Functions.ShaderEnabled(p))
        {
            DisableShader();
            return;
        }

        bool affineOn = PS1Functions.AffineEnabled(p);
        bool snapOn   = PS1Functions.SnapEnabled(p);
        bool ditherOn = PS1Functions.DitherEnabled(p);
        int  colorD   = PS1Functions.GetColorDepth(p);

        if (!affineOn && !snapOn && !ditherOn && colorD == 0)
        {
            DisableShader();
            return;
        }

        int flags = 0;
        if (affineOn) { flags |= 1; }
        if (snapOn)   { flags |= 2; }
        if (ditherOn) { flags |= 4; }
        flags |= (colorD & 0xF) << 4;

        int snapIdx   = PS1Functions.GetSnapIndex(p);
        int affineInt = clamp(int(PS1Functions.GetAffineStrength(p) * 50.0), 0, 150);
        int params    = (snapIdx & 0xFF) | ((affineInt & 0xFF) << 8);

        Shader.SetEnabled(p, "ps1shader", true);
        Shader.SetUniform1i(p, "ps1shader", "ps1Flags",  flags);
        Shader.SetUniform1i(p, "ps1shader", "ps1Params", params);
    }

    private ui void DisableShader()
    {
        if (consoleplayer >= 0 && consoleplayer < MAXPLAYERS && PlayerInGame[consoleplayer])
        {
            Shader.SetEnabled(players[consoleplayer], "ps1shader", false);
        }
    }
}
