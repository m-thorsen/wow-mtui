local MTUI = LibStub("AceAddon-3.0"):GetAddon("MTUI")

local options

-- local function GetRgb(c)
--     return c.r, c.g, c.b
-- end

local function IsNameplate(unit)
    return type(unit) == "string" and (string.match(unit, "nameplate") == "nameplate" or string.match(unit, "NamePlate") == "NamePlate")
end

local function UpdateStatusBarTexture(self, ...)
    if not IsNameplate(self.unit) then return end
    local texture = MTUI.db.profile.mediaPath..MTUI.db.profile.texture
    self.healthBar:SetStatusBarTexture(texture)
    self.castBar:SetStatusBarTexture(texture)
    if (ClassNameplateManaBarFrame) then
        ClassNameplateManaBarFrame:SetStatusBarTexture(texture)
    end
end

-- local function UpdateNameColor(self, ...)
--     if not IsNameplate(self.unit) then return end

--     self.name:SetVertexColor(1, 1, 1)
--     self.name:SetFont(UNIT_NAME_FONT, 8);
-- end

-- local function UpdateStatusBarColor(self)
--     if not IsNameplate(self.unit) then return end
--     local r, g, b = UnitSelectionColor(self.unit)
--     local threat = UnitThreatSituation("player", self.unit)
--     if threat == 3 then
--         r, g, b = GetRgb(RED_FONT_COLOR)
--     elseif threat == 2 then
--         r, g, b = GetRgb(ORANGE_FONT_COLOR)
--     elseif threat == 1 then
--         r, g, b = GetRgb(YELLOW_FONT_COLOR)
--     end
--     self.healthBar:SetStatusBarColor(r * options.unitColorMod, g * options.unitColorMod, b * options.unitColorMod)
-- end

function MTUI:InitializePlates()
    options = self.db.profile

    -- hooksecurefunc("CompactUnitFrame_UpdateName", UpdateNameColor)
    hooksecurefunc("CompactUnitFrame_UpdateName", UpdateStatusBarTexture)
    -- hooksecurefunc("CompactUnitFrame_UpdateAggroFlash", UpdateStatusBarColor)
    -- hooksecurefunc("CompactUnitFrame_UpdateHealthColor", UpdateStatusBarColor)
    hooksecurefunc("DefaultCompactNamePlateFrameAnchorInternal", function(frame, ...)
        if not IsNameplate(frame.unit) then return end

        frame.healthBar:SetHeight(6)
        frame.name:SetPoint("BOTTOM", frame.healthBar, "TOP", 0, 1)
        frame.name:SetFont(UNIT_NAME_FONT, 8)
        frame.castBar.Text:SetFont(UNIT_NAME_FONT, 6)
    end)
end
