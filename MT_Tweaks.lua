local eventFrame = CreateFrame("Frame", "MT_Tweaks", UIParent);

eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
eventFrame:RegisterEvent("ADDON_LOADED");
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if (event == "ADDON_LOADED" and addonName == 'MT_UI') then
        function HelpTip:AreHelpTipsEnabled()
            return false
        end;
    end;

    if (event == "PLAYER_ENTERING_WORLD") then
        local inInstance, instanceType = IsInInstance();
        SetCVar("nameplateShowAll", inInstance and 1 or 0);
    end;
end);
