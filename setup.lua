MTUI = {
    unitframes = {
        offsetY         = 200,
        offsetX         = 250,
    },
    actionbars = {
        scale           = 1,
        stacked         = true,
        spacing         = 1,
        trackHeight     = 10,
        hideStance      = false,
        hideMicro       = true,
        rightOffsetY    = 0,
    },
    textures = {
        statusbar       = "Interface/Addons/MTUI/Media/statusbar",
        raidbar         = "Interface/Addons/MTUI/Media/raidbar",
    },
    castingbar = {
        width           = 220,
    },
}

local MTUIFrame = CreateFrame("Frame", "MTUIFrame", UIParent);

MTUIFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
MTUIFrame:RegisterEvent("ADDON_LOADED");
MTUIFrame:SetScript("OnEvent", function(frame, event, addonName)
    if (event == "ADDON_LOADED" and addonName == 'MTUI') then
        function HelpTip:AreHelpTipsEnabled() return false end;

        MTUI:InitActionbars();
        MTUI:InitCastingbar();
        MTUI:InitUnitframes();
        MTUI:InitMoveFrames();

    elseif (event == "PLAYER_ENTERING_WORLD") then
        MTUI:InitStatusbars();
        -- MTUI:InitMinorStatusbars():
        -- MTUI:InitNameplates();

        local inInstance, instanceType = IsInInstance();
        if (inInstance) then
            SetCVar("nameplateShowAll", 1);
        else
            SetCVar("nameplateShowAll", 0);
        end;
    end;
end)
