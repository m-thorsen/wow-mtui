local MTUI = LibStub("AceAddon-3.0"):GetAddon("MTUI");

-- Return an appropriate unit color based on class (or threat situation)
function MTUI:GetUnitColor(unit, useThreatColors)
    if (UnitIsTapDenied(unit) or not UnitIsConnected(unit)) then
        return GRAY_FONT_COLOR:GetRGB();

    elseif (UnitIsPlayer(unit) and UnitClass(unit)) then
        local _, class = UnitClass(unit);
        local c = RAID_CLASS_COLORS[class];
        return c.r, c.g, c.b;

    elseif (UnitReaction(unit, "player") and UnitReaction(unit, "player") > 4) then
        return GREEN_FONT_COLOR:GetRGB();

    elseif (useThreatColors) then
        threatLevel = UnitThreatSituation("player", unit);

        if (threatLevel == 3) then
            return RED_FONT_COLOR:GetRGB();

        elseif (threatLevel == 2) then
            return ORANGE_FONT_COLOR:GetRGB();

        elseif (threatLevel == 1) then
            return YELLOW_FONT_COLOR:GetRGB();

        elseif (threatLevel ~= nil) then
            return GREEN_FONT_COLOR:GetRGB();

        end;
    end;

    return UnitSelectionColor(unit, true);
end;
