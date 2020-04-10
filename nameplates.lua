local MTUI = LibStub("AceAddon-3.0"):GetAddon("MTUI")

local options

local function GetRgb(c)
    return c.r, c.g, c.b
end

local function IsNameplate(unit)
    if type(unit) ~= "string" then return false end

	if (string.match(unit, "nameplate") ~= "nameplate" and string.match(unit, "NamePlate") ~= "NamePlate") then
		return false
	else
		return true
	end
end

local function IsHostileNPC(unit)
    return UnitIsEnemy("player", unit) and not UnitIsPlayer(unit)
end

local function OnUpdateName(self, ...)
    if not IsNameplate(self.unit) then return end

    local texture = MTUI.db.profile.mediaPath..MTUI.db.profile.texture

    self.healthBar:SetStatusBarTexture(texture)
    self.castBar:SetStatusBarTexture(texture)

    if (ClassNameplateManaBarFrame) then
        ClassNameplateManaBarFrame:SetStatusBarTexture(texture)
    end

    if not UnitIsPlayer(self.unit) and UnitThreatSituation("player", self.unit) ~= nil then
        self.name:SetVertexColor(1, 1, 1)
    end
end

local function OnUpdateStatusBar(self)
    if not IsNameplate(self.unit) then return end

    local r, g, b = UnitSelectionColor(self.unit)

    if threat == 3 then
        r, g, b = GetRgb(RED_FONT_COLOR)
    elseif threat == 2 then
        r, g, b = GetRgb(ORANGE_FONT_COLOR)
    elseif threat == 1 then
        r, g, b = GetRgb(YELLOW_FONT_COLOR)
    end

    self.healthBar:SetStatusBarColor(r * options.unitColorMod, g * options.unitColorMod, b * options.unitColorMod)
end

function MTUI:InitializePlates()
    options = self.db.profile
    hooksecurefunc("CompactUnitFrame_UpdateHealthColor", OnUpdateStatusBar)
    hooksecurefunc("CompactUnitFrame_UpdateAggroFlash", OnUpdateStatusBar)
    hooksecurefunc("CompactUnitFrame_UpdateName", OnUpdateName)
end
