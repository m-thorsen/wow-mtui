local MTUI = LibStub("AceAddon-3.0"):GetAddon("MTUI")

local options

local function GetRgb(c)
    return c.r, c.g, c.b
end

local function IsNameplate(unit)
    return type(unit) == "string" and (string.match(unit, "nameplate") == "nameplate" or string.match(unit, "NamePlate") == "NamePlate")
end

local function UpdateStatusBarColor(frame, ...)
    if not IsNameplate(frame.unit) then return end

    local r, g, b = UnitSelectionColor(frame.unit, true)

    if UnitReaction(frame.unit, "player") and UnitReaction(frame.unit, "player") > 4 then
        frame.healthBar:SetStatusBarColor(0, 0.85, 0)
    elseif UnitIsTapDenied(frame.unit) and not UnitPlayerControlled(frame.unit) then
        frame.healthBar:SetStatusBarColor(0.5, 0.5, 0.5)
    else
        local threat = UnitThreatSituation("player", frame.unit)

        if threat == 3 then
            r, g, b = GetRgb(RED_FONT_COLOR)
        elseif threat == 2 then
            r, g, b = GetRgb(ORANGE_FONT_COLOR)
        elseif threat == 1 then
            r, g, b = GetRgb(YELLOW_FONT_COLOR)
        end
        frame.healthBar:SetStatusBarColor(r, g, b)
    end
end

function MTUI:InitializePlates()
    options = self.db.profile

    hooksecurefunc("CompactUnitFrame_UpdateAggroFlash", UpdateStatusBarColor)
    hooksecurefunc("CompactUnitFrame_UpdateHealthColor", UpdateStatusBarColor)

    hooksecurefunc("CompactUnitFrame_UpdateName", function(frame, ...)
        if not IsNameplate(frame.unit) then return end

        local texture = options.mediaPath..options.barTexture
        frame.healthBar:SetStatusBarTexture(texture)
        frame.castBar:SetStatusBarTexture(texture)
        if (ClassNameplateManaBarFrame) then
            ClassNameplateManaBarFrame:SetStatusBarTexture(texture)
        end
        frame.name:SetVertexColor(1, 1, 1)
        frame.name:SetFont(UNIT_NAME_FONT, 8)
    end)

    hooksecurefunc("DefaultCompactNamePlateFrameAnchorInternal", function(frame, ...)
        if not IsNameplate(frame.unit) then return end

        frame.castBar.Text:SetFont(UNIT_NAME_FONT, 6)
        frame.healthBar:SetHeight(6)
        frame.selectionHighlight:Hide()
    end)
end
