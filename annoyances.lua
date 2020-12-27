local MTUI = LibStub("AceAddon-3.0"):GetAddon("MTUI");

local annoyingSounds = {
    56593, 56594, -- Male BE attack crit/DH charge https://www.wowhead.com/sound=56594/vo-pcdhbloodelfmale-attackcrit
};

function MTUI:InitAnnoyances()
    -- Hides annoying alerts
    function MainMenuMicroButton_AreAlertsEffectivelyEnabled() return false; end;
    -- Hides tutorial tooltips
    function HelpTip:AreHelpTipsEnabled() return false; end;


    -- for _, sound in next, annoyingSounds do
    --     -- MuteSound(sound);
    -- end;
end;
