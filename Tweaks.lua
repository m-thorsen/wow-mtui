local _, MTUI = ...

function MTUI.applyInstanceSettings()
    -- Other possible settings:
    -- graphicsViewDistance
    -- graphicsEnvironmentDetail
    SetCVar("nameplateShowEnemies", 1)

    if IsInInstance() then
        SetCVar("nameplateShowAll", 1)
        SetCVar("graphicsGroundClutter", 1)
    else
        SetCVar("nameplateShowAll", 0)
        SetCVar("graphicsGroundClutter", 9)
    end
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

function MTUI.applyDefaultAuctionHouseFilters()
    AUCTION_HOUSE_DEFAULT_FILTERS[Enum.AuctionHouseFilter.CurrentExpansionOnly] = true
    AUCTION_HOUSE_DEFAULT_FILTERS[Enum.AuctionHouseFilter.PoorQuality] = false
end
