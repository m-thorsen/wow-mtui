local function IsNameplate(unit)
    return type(unit) == "string" and (string.match(unit, "nameplate") == "nameplate" or string.match(unit, "NamePlate") == "NamePlate");
end;

local function SetNameplateColor(frame)
    if not IsNameplate(frame.unit) then return end;

    frame.healthBar:SetStatusBarColor(MTUI:GetUnitColor(frame.unit, true));
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
