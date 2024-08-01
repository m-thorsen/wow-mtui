local eventFrame = CreateFrame("Frame", "MT_Tweaks", UIParent);

eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if (event == "PLAYER_ENTERING_WORLD" and addonName == 'MTUI') then
        local inInstance, instanceType = IsInInstance();
        SetCVar("nameplateShowAll", inInstance and 1 or 0);
    end;
end);
