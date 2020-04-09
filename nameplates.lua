local MTUI = LibStub("AceAddon-3.0"):GetAddon("MTUI")

local function GetRGB(c)
    local color = _G[c:upper() .. "_FONT_COLOR"]
    return color.r, color.g, color.b
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

local function UpdateName(self, ...)
    if not IsNameplate(self.unit) then return end

    self.healthBar:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Resource-Fill")
    self.castBar:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Resource-Fill")

    if (ClassNameplateManaBarFrame) then
        ClassNameplateManaBarFrame:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Resource-Fill")
    end

    if not IsHostileNPC(self.unit) then
        return
    end

    if UnitThreatSituation("player", self.unit) == nil then
        self.name:SetVertexColor(UnitSelectionColor(self.unit, true))
    else
        self.name:SetVertexColor(1, 1, 1)
    end
end

local function UpdateStatusBar(self)
    if not IsNameplate(self.unit) or not IsHostileNPC(self.unit) then return end

    if threat == nil then
        self.healthBar:SetStatusBarColor(UnitSelectionColor(self.unit, true))
        -- frame.healthBar:SetScale(1)
    elseif threat == 3 then
        self.healthBar:SetStatusBarColor(GetRGB("RED"))
    elseif threat == 2 then
		self.healthBar:SetStatusBarColor(GetRGB("ORANGE"))
    elseif threat == 1 then
		self.healthBar:SetStatusBarColor(GetRGB("YELLOW"))
    else
		self.healthBar:SetStatusBarColor(GetRGB("GREEN"))
    end
end

function MTUI:InitializePlates()
    -- SetCVar("nameplateOtherBottomInset", 0.1)
    -- SetCVar("nameplateOtherTopInset", 0.1)
    -- SetCVar("nameplateOverlapV", 0.5)
    -- SetCVar("nameplateOverlapV", 0.5)
    -- SetCVar("nameplateMotion", 1)
    -- SetCVar("nameplateMotionSpeed", 0.5)
    hooksecurefunc("CompactUnitFrame_UpdateHealthColor", UpdateStatusBar)
    hooksecurefunc("CompactUnitFrame_UpdateAggroFlash", UpdateStatusBar)
    hooksecurefunc("CompactUnitFrame_UpdateName", UpdateName)
end
