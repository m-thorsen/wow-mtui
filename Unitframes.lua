local _, MTUI = ...

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

local function SetHealthbarColor(bar)
    if not UnitExists(bar.unit) then return end
    bar:SetStatusBarDesaturated(1)
    bar:SetStatusBarColor(GetUnitColor(bar.unit))
end

function MTUI.initUnitFrames()
    hooksecurefunc("UnitFrameHealthBar_Update", SetHealthbarColor)
end
