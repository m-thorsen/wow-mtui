local frame = CreateFrame("Frame", "MTUI_EventFrame", UIParent);

local function showNameplatesInInstances() 
    local inInstance, instanceType = IsInInstance()
    SetCVar("nameplateShowAll", inInstance and 1 or 0)
end

local function moveAlertFrame()
    hooksecurefunc(AlertFrame, "AddAlertFrame", function()
        AlertFrame:ClearAllPoints()
        AlertFrame:SetPoint("BOTTOM", UIParent, "CENTER", 0, 200)
    end)
    
    -- Test!
    -- MoneyWonAlertSystem:AddAlert(666);
    -- HonorAwardedAlertSystem:AddAlert(667);
    -- EntitlementDeliveredAlertSystem:AddAlert("ENTITLEMENT_DELIVERED");
    -- EntitlementDeliveredAlertSystem:AddAlert("ENTITLEMENT_DELIVERED");
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
