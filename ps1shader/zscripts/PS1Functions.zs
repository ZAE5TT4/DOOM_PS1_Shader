class PS1Functions : Object
{
    static bool ShaderEnabled(PlayerInfo p)
    {
        let cv = CVar.GetCVar('ps1_shader_enable', p);
        if (cv == null) { return true; }
        return cv.GetBool();
    }

    static bool AffineEnabled(PlayerInfo p)
    {
        let cv = CVar.GetCVar('ps1_affine_enable', p);
        if (cv == null) { return true; }
        return cv.GetBool();
    }

    static bool SnapEnabled(PlayerInfo p)
    {
        let cv = CVar.GetCVar('ps1_snap_enable', p);
        if (cv == null) { return true; }
        return cv.GetBool();
    }

    static bool DitherEnabled(PlayerInfo p)
    {
        let cv = CVar.GetCVar('ps1_dither_enable', p);
        if (cv == null) { return true; }
        return cv.GetBool();
    }

    static int GetSnapIndex(PlayerInfo p)
    {
        let cv = CVar.GetCVar('ps1_snap_resolution', p);
        if (cv == null) { return 3; }
        return clamp(cv.GetInt(), 0, 7);
    }

    static float GetAffineStrength(PlayerInfo p)
    {
        let cv = CVar.GetCVar('ps1_affine_strength', p);
        if (cv == null) { return 1.0; }
        return clamp(cv.GetFloat(), 0.0, 3.0);
    }

    static int GetColorDepth(PlayerInfo p)
    {
        let cv = CVar.GetCVar('ps1_color_depth', p);
        if (cv == null) { return 3; }
        return clamp(cv.GetInt(), 0, 5);
    }
}
