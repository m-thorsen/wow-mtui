local name, MTUI = ...

MTUI.options = {
    showMenuAndTargetActionInTooltips = false
}

local f = CreateFrame("Frame");
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD") -- Logon/reloadUI
f:RegisterEvent("ZONE_CHANGED_NEW_AREA") -- Entering/leaving instances or zones
-- f:RegisterEvent("ZONE_CHANGED") -- Changed sub zone
-- f:RegisterEvent("ZONE_CHANGED_INDOORS") -- Changed sub zone (indoors)
f:SetScript("OnEvent", function(self, event, addonName)
    if event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA" then
        MTUI.applyInstanceSettings()
        MTUI.initCellTooltips()
        -- MTUI.initClickcastTooltips()
    elseif event == "ADDON_LOADED" and addonName == name then
        MTUI.moveAlertFrame()
        MTUI.initUnitFrames()
    elseif event == "ADDON_LOADED" and addonName == "Blizzard_AuctionHouseUI" then
        MTUI.applyDefaultAuctionHouseFilters()
    end
end)


