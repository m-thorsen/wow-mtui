local _, MTUI = ...

function MTUI.showNameplatesInInstances()
    local oldState = GetCVar("nameplateShowAll")
    local newState = IsInInstance() and 1 or 0

    if oldState ~= nil and tonumber(oldState) == newState then
        return
    end

    SetCVar("nameplateShowAll", newState)
    print(newState == 1 and 'MTUI nameplates: ON' or 'MTUI nameplates: OFF')
end

function MTUI.moveAlertFrame()
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

