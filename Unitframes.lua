local function GetUnitColor(unit)
    local r, g, b

    if UnitIsTapDenied(unit) or not UnitIsConnected(unit) then
        -- tapped
        r, g, b = GRAY_FONT_COLOR:GetRGB()
    elseif UnitIsPlayer(unit) and UnitClass(unit) then
        -- players
        local _, className = UnitClass(unit)
        r, g, b = RAID_CLASS_COLORS[className]:GetRGB()
    elseif UnitIsUnit(unit, 'pet') and UnitClass(unit) then
        -- my pet
        local _, className = UnitClass('player')
        r, g, b = RAID_CLASS_COLORS[className]:GetRGB()
    elseif UnitPlayerControlled(unit) then
        -- other players' pets?
        r, g, b = UnitSelectionColor(unit, true)
    elseif UnitReaction(unit, "player") and UnitReaction(unit, "player") > 4 then
        r, g, b = GREEN_FONT_COLOR:GetRGB()
    else
        r, g, b = UnitSelectionColor(unit, true)
    end

    return r, g, b
end

local function SetStatusbarTexture(bar)
    -- bar:SetStatusBarDesaturated(1)
    -- bar:SetStatusBarTexture('Interface/Targetingframe/UI-Statusbar')
end

local function SetHealthbarColor(bar)
    if not UnitExists(bar.unit) then return end
    bar:SetStatusBarDesaturated(1)
    bar:SetStatusBarColor(GetUnitColor(bar.unit))
end

local eventFrame = CreateFrame("Frame", "MT_Unitframes", UIParent)
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if (event == "ADDON_LOADED" and addonName == 'MTUI') then
        hooksecurefunc("UnitFrameHealthBar_Update", SetHealthbarColor)
        -- hooksecurefunc("UnitFrameHealthBar_Update", SetStatusbarTexture)
        -- hooksecurefunc("UnitFrameManaBar_Update", SetStatusbarTexture)
    end
end)