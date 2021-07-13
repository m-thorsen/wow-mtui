local function IsNameplate(unit)
    return type(unit) == "string" and (string.match(unit, "nameplate") == "nameplate" or string.match(unit, "NamePlate") == "NamePlate");
end;

local function GetUnitColor(unit)
    local threatLevel = UnitThreatSituation("player", unit);

    if (UnitIsTapDenied(unit) or not UnitIsConnected(unit)) then
        return GRAY_FONT_COLOR:GetRGB();
    elseif (UnitIsPlayer(unit) and UnitClass(unit)) then
        local _, class = UnitClass(unit);
        local c = RAID_CLASS_COLORS[class];
        return c.r, c.g, c.b;
    elseif (UnitReaction(unit, "player") and UnitReaction(unit, "player") > 4) then
        return GREEN_FONT_COLOR:GetRGB();
    elseif (threatLevel == 3) then
        return RED_FONT_COLOR:GetRGB();
    elseif (threatLevel == 2) then
        return ORANGE_FONT_COLOR:GetRGB();
    elseif (threatLevel == 1) then
        return YELLOW_FONT_COLOR:GetRGB();
    elseif (threatLevel ~= nil) then
        return GREEN_FONT_COLOR:GetRGB();
    else
        return UnitSelectionColor(unit, true);
    end;
end;


local function SetNameplateColor(frame)
    if not IsNameplate(frame.unit) then return end;

    frame.healthBar:SetStatusBarColor(GetUnitColor(frame.unit));
end;

local function SetNameplateTexture(frame, ...)
    if not IsNameplate(frame.unit) then return end;

    frame.healthBar:SetStatusBarTexture(MTUI.textures.raidbar);
    frame.castBar:SetStatusBarTexture(MTUI.textures.raidbar);
    frame.castBar.Flash:SetTexture(nil);
    if (ClassNameplateManaBarFrame) then
        ClassNameplateManaBarFrame:SetStatusBarTexture(MTUI.textures.raidbar);
    end;

    frame.name:SetFont(frame.name:GetFont(), 8, nil);
    frame.name:SetVertexColor(1, 1, 1);
end;


local function SetNameplateSize(frame, ...)
    frame.UnitFrame.name:SetPoint("BOTTOM", frame.UnitFrame.healthBar, "TOP", 0, 2);
    frame.UnitFrame.castBar.Text:SetFont(frame.UnitFrame.name:GetFont(), 7, nil);
    frame.UnitFrame.healthBar:SetHeight(6);
    frame.UnitFrame.selectionHighlight:SetAlpha(0);
    frame.UnitFrame.BuffFrame:SetBaseYOffset(-5);
    frame.UnitFrame.BuffFrame:SetTargetYOffset(-5);
end;

function MTUI:InitNameplates()
    hooksecurefunc("CompactUnitFrame_UpdateAggroFlash", SetNameplateColor);
    hooksecurefunc("CompactUnitFrame_UpdateHealthColor", SetNameplateColor);
    hooksecurefunc("CompactUnitFrame_UpdateName", SetNameplateTexture);
    hooksecurefunc(NamePlateBaseMixin, "ApplyOffsets", SetNameplateSize);
    hooksecurefunc(NamePlateBaseMixin, "OnSizeChanged", SetNameplateSize);
end;
