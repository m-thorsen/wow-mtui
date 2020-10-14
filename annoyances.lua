local MTUI = LibStub("AceAddon-3.0"):GetAddon("MTUI");

function MTUI:InitAnnoyances()
    -- Hide annoying alerts
    function MainMenuMicroButton_AreAlertsEffectivelyEnabled()
        return false;
    end;
end;
