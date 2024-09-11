local frame = CreateFrame("Frame", "MTUI_EventFrame", UIParent);

local function showNameplatesInInstances()
    SetCVar("nameplateShowAll", IsInInstance() and 1 or 0)
end

local function moveAlertFrame()
    hooksecurefunc(AlertFrame, "UpdateAnchors", function(self,...)
        local spacing = 10
        local totalHeight = spacing
        for _, alertFrameSubSystem in ipairs(self.alertFrameSubSystems) do
            if alertFrameSubSystem.alertFramePool then
                for f in alertFrameSubSystem.alertFramePool:EnumerateActive() do				
                    totalHeight = totalHeight + f:GetHeight() + spacing
                end
            end
        end
        self:ClearAllPoints()
        self:SetPoint("TOP", UIParent, "TOP", 0, totalHeight * -1)
    end)
    -- Test!
    -- MoneyWonAlertSystem:AddAlert(666);
    -- MoneyWonAlertSystem:AddAlert(666);
    -- HonorAwardedAlertSystem:AddAlert(667);
    -- HonorAwardedAlertSystem:AddAlert(667);
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
