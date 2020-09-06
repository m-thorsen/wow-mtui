local MTUI = LibStub("AceAddon-3.0"):GetAddon("MTUI")

local options

local function IsNameplate(unit)
    return type(unit) == "string" and (string.match(unit, "nameplate") == "nameplate" or string.match(unit, "NamePlate") == "NamePlate")
end

local function UpdateStatusBarColor(frame, ...)
    if not IsNameplate(frame.unit) then return end

    if UnitReaction(frame.unit, "player") and UnitReaction(frame.unit, "player") > 4 then
        frame.healthBar:SetStatusBarColor(GREEN_FONT_COLOR:GetRGB())
    elseif UnitIsTapDenied(frame.unit) and not UnitPlayerControlled(frame.unit) then
        frame.healthBar:SetStatusBarColor(GRAY_FONT_COLOR:GetRGB())
    else
        local threat = UnitThreatSituation("player", frame.unit)

        if threat == 3 then
            r, g, b = RED_FONT_COLOR:GetRGB()
        elseif threat == 2 then
            r, g, b = ORANGE_FONT_COLOR:GetRGB()
        elseif threat == 1 then
            r, g, b = YELLOW_FONT_COLOR:GetRGB()
        elseif threat ~= nil then
            r, g, b = GREEN_FONT_COLOR:GetRGB()
        else
            r, g, b = UnitSelectionColor(frame.unit, true)
        end

        frame.healthBar:SetStatusBarColor(r, g, b)
    end
end

function MTUI:InitializePlates()
    options = self.db.global

    hooksecurefunc("CompactUnitFrame_UpdateAggroFlash", UpdateStatusBarColor)
    hooksecurefunc("CompactUnitFrame_UpdateHealthColor", UpdateStatusBarColor)

    hooksecurefunc("CompactUnitFrame_UpdateName", function(frame, ...)
        if not IsNameplate(frame.unit) then return end

        if options.enableTexture then
            local texture = options.namePlateTexture
            frame.healthBar:SetStatusBarTexture(texture)
            frame.castBar:SetStatusBarTexture(texture)
            frame.castBar.Flash:SetTexture(nil)
            if (ClassNameplateManaBarFrame) then
                ClassNameplateManaBarFrame:SetStatusBarTexture(texture)
            end
        end

        frame.name:SetVertexColor(1, 1, 1)
        frame.name:SetFont(UNIT_NAME_FONT, 8, nil)
    end)

    hooksecurefunc("DefaultCompactNamePlateFrameAnchorInternal", function(frame, ...)
        if not IsNameplate(frame.unit) then return end

        frame.castBar.Text:SetFont(UNIT_NAME_FONT, 6, nil)
        frame.healthBar:SetHeight(6)
        frame.healthBar.border:SetScale(0.5)
        frame.healthBar.border:SetAlpha(0.75)
        frame.selectionHighlight:Hide()
        -- frame.selectionHighlight:SetAlpha(0.5)
    end)
end
