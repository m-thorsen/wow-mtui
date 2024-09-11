local name, MTUI = ...

MTUI.options = {
    showMenuAndTargetActionInTooltips = false
}

local f = CreateFrame("Frame", "MTUI_Frame", UIParent);
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event, addonName)
    if (event == "PLAYER_ENTERING_WORLD") then
        MTUI.showNameplatesInInstances()
        MTUI.initCellTooltips()
        -- MTUI.initClickcastTooltips()
    end

    if (event == "ADDON_LOADED" and addonName == name) then
        MTUI.moveAlertFrame()
        MTUI.initUnitFrames()
    end
end)
