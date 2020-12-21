local MTUI = LibStub("AceAddon-3.0"):GetAddon("MTUI");

local function IsNameplate(unit)
    return type(unit) == "string" and (string.match(unit, "nameplate") == "nameplate" or string.match(unit, "NamePlate") == "NamePlate");
end;

local function SetNameplateColor(frame)
    if IsNameplate(frame.unit) then
        frame.healthBar:SetStatusBarColor(MTUI:GetUnitColor(frame.unit, true));
    end;
end;

local function SetNameplateTexture(frame, ...)
    if not IsNameplate(frame.unit) then return end;

    if MTUI.db.global.enableStatusbars then
        local texture = MTUI.db.global.nameplateTexture;
        frame.healthBar:SetStatusBarTexture(texture);
        frame.castBar:SetStatusBarTexture(texture);
        frame.castBar.Flash:SetTexture(nil);
        if (ClassNameplateManaBarFrame) then
            ClassNameplateManaBarFrame:SetStatusBarTexture(texture);
        end;
    end;

    frame.name:SetFont(frame.name:GetFont(), 8, nil);
    frame.name:SetVertexColor(1, 1, 1);
end;

local function SetNameplateSize(frame, ...)
    if not IsNameplate(frame.unit) then return end;

    -- NamePlateDriverMixin:SetBaseNamePlateSize(128, 64);
    frame.name:SetPoint("BOTTOM", frame.healthBar, "TOP", 0, 2);
    frame.castBar.Text:SetFont(frame.name:GetFont(), 7, nil);
    frame.healthBar:SetHeight(7);
    frame.selectionHighlight:Hide();
end;

function MTUI:InitNameplates()
    hooksecurefunc("CompactUnitFrame_UpdateAggroFlash", SetNameplateColor);
    hooksecurefunc("CompactUnitFrame_UpdateHealthColor", SetNameplateColor);
    hooksecurefunc("CompactUnitFrame_UpdateName", SetNameplateTexture);
    hooksecurefunc("CompactUnitFrame_UpdateName", SetNameplateSize);
    hooksecurefunc("DefaultCompactNamePlateFrameAnchorInternal", SetNameplateSize);
end;
