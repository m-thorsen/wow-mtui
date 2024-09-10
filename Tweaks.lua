local frame = CreateFrame("Frame", "MTUI_EventFrame", UIParent);

local function showNameplatesInInstances() 
    local inInstance, instanceType = IsInInstance()
    SetCVar("nameplateShowAll", inInstance and 1 or 0)
end

local function moveAlertFrame()
    hooksecurefunc(AlertFrame, "UpdateAnchors", function()
        AlertFrame:ClearAllPoints()
        AlertFrame:SetPoint("TOP", UIParent, "TOP", 0, -200)
    end)
    
    -- Test!
    -- MoneyWonAlertSystem:AddAlert(666);
end

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event, addonName)
    if (event == "PLAYER_ENTERING_WORLD") then
        showNameplatesInInstances()
    end

    if (event == "ADDON_LOADED" and addonName == "MTUI") then
        moveAlertFrame()
    end
end)
