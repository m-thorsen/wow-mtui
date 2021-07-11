local MTUI = LibStub("AceAddon-3.0"):GetAddon("MTUI");

local function DisableHelpTips()
    -- Hides annoying alerts
    -- function MainMenuMicroButton_AreAlertsEffectivelyEnabled() return false; end;
    -- Hides tutorial tooltips
    function HelpTip:AreHelpTipsEnabled() return false; end;
end;

local function ToggleCombatPlatesInInstances()
    local EventFrame = CreateFrame("Frame", "MTUIEventFrame", UIParent);
    EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
    EventFrame:SetScript("OnEvent", function(self, event, ...)
        if (event == "PLAYER_ENTERING_WORLD") then
            local inInstance, instanceType = IsInInstance();
            if (inInstance) then
                SetCVar("nameplateShowAll", 1);
            else
                SetCVar("nameplateShowAll", 0);
            end;
        end;
    end);
end;

function MTUI:InitAutomation()
    DisableHelpTips();
    ToggleCombatPlatesInInstances();
end;
