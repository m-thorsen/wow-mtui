local MTUI = LibStub("AceAddon-3.0"):GetAddon("MTUI")

local options

local function ApplyCommonFrameTweaks(self)
    self.name:ClearAllPoints()
    self.healthbar:ClearAllPoints()
    self.healthbar:SetHeight(28)
    self.healthbar.LeftText:SetPoint("LEFT", self.healthbar, "LEFT", 3, 0)
    self.healthbar.RightText:SetPoint("RIGHT", self.healthbar, "RIGHT", -3, 0)
    self.healthbar.TextString:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0)
end

local function TweakPlayerFrame(self)
    PlayerFrameTexture:SetTexture("Interface/Addons/MTUI/Media/TargetFrame")
    PlayerStatusTexture:SetTexture("Interface/Addons/MTUI/Media/Player-Status")
    PlayerStatusTexture:SetWidth(192)
    ApplyCommonFrameTweaks(self)
    self.healthbar:SetPoint("TOPRIGHT", -5, -24)
    self.name:Hide()
    self.name:SetPoint("CENTER", self, "CENTER", 50.5, 36)
end

local function TweakVehicleFrame(self, vehicle)
    self.healthbar:ClearAllPoints()
    self.manabar:ClearAllPoints()
    if (vehicle == "Natural") then
        PlayerFrameVehicleTexture:SetTexture("Interface/Vehicles/UI-Vehicle-Frame-Organic")
        PlayerFrameFlash:SetTexture("Interface/Vehicles/UI-Vehicle-Frame-Organic-Flash")
        PlayerFrameFlash:SetTexCoord(-0.02, 1, 0.07, 0.86)
        self.healthbar:SetSize(103, 12)
        self.healthbar:SetPoint("TOPLEFT", 116, -41)
        self.manabar:SetSize(103, 12)
        self.manabar:SetPoint("TOPLEFT", 116, -52)
    else
        PlayerFrameVehicleTexture:SetTexture("Interface/Vehicles/UI-Vehicle-Frame")
        PlayerFrameFlash:SetTexture("Interface/Vehicles/UI-Vehicle-Frame-Flash")
        PlayerFrameFlash:SetTexCoord(-0.02, 1, 0.07, 0.86)
        self.healthbar:SetPoint("TOPLEFT", 119, -41)
        self.healthbar:SetSize(100, 12)
        self.manabar:SetSize(100, 12)
        self.manabar:SetPoint("TOPLEFT", 119, -52)
    end
    PlayerName:SetPoint("CENTER",50,23)
    PlayerFrameBackground:SetWidth(114)
end

local function TweakTargetFrame(self)
    local type = UnitClassification(self.unit)

    self.nameBackground:Hide()

    if (not self.texture) then
        local tex = self:CreateTexture(nil, "BACKGROUND")
        tex:SetTexture("Interface/Addons/MTUI/Media/Frames/TargetingFrameShadow")
        tex:SetPoint("TOPLEFT", self, "TOPLEFT", -25, 16)
        tex:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 20, 0)
        self.texture = tex
    end

    ApplyCommonFrameTweaks(self)

    self.threatNumericIndicator:SetPoint("BOTTOM", PlayerFrame, "TOP", 72, -21)
    self.deadText:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0)
    self.deadText:SetTextColor(0.5, 0.5, 0.5)

    self.healthbar:ClearAllPoints()
    self.Background:SetPoint("TOP", self.healthbar, "TOP", 0, 0)

    if (type == "minus") then
        self.texture:Hide()
        self.name:SetPoint("LEFT", self, 16, 17)
        self.healthbar:SetPoint("LEFT", 5, 3)
        self.healthbar:SetHeight(12)
        self.Background:SetHeight(12)
        if (self.threatIndicator) then
            self.threatIndicator:SetTexture("Interface/TargetingFrame/UI-TargetingFrame-Minus-Flash")
            self.threatIndicator:SetTexCoord(0, 1, 0, 1)
            self.threatIndicator:SetWidth(256)
            self.threatIndicator:SetHeight(128)
            self.threatIndicator:SetPoint("TOPLEFT", self, "TOPLEFT", -24, 0)
        end
    else
        self.texture:Show()
        self.name:SetPoint("LEFT", self, 15, 36)
        self.healthbar:SetPoint("TOPLEFT", 5, -24)
        self.Background:SetHeight(40)
        if (type == "worldboss" or type == "elite") then
            self.borderTexture:SetTexture("Interface/Addons/MTUI/Media/TargetFrame-Elite")
        elseif (type == "rareelite") then
            self.borderTexture:SetTexture("Interface/Addons/MTUI/Media/TargetFrame-RareElite")
        elseif (type == "rare") then
            self.borderTexture:SetTexture("Interface/Addons/MTUI/Media/TargetFrame-Rare")
        else
            self.borderTexture:SetTexture("Interface/Addons/MTUI/Media/TargetFrame")
        end
        if (self.threatIndicator) then
            self.threatIndicator:SetTexCoord(0, 0.9453125, 0, 0.181640625)
            self.threatIndicator:SetWidth(242)
            self.threatIndicator:SetHeight(93)
            self.threatIndicator:SetPoint("TOPLEFT", self, "TOPLEFT", -24, 0)
        end
    end
end

-- Duplicate from nameplates?
local function ColorizeHealthbar(healthBar, unit)
    if not UnitExists(unit) then return end

    if UnitIsTapDenied(unit) or not UnitIsConnected(unit) then
        healthBar:SetStatusBarColor(GRAY_FONT_COLOR:GetRGB())
    elseif UnitIsPlayer(unit) and UnitClass(unit) then
        local _, class = UnitClass(unit)
        local c = RAID_CLASS_COLORS[class]
        healthBar:SetStatusBarColor(c.r, c.g, c.b)
    elseif UnitReaction(unit, "player") and UnitReaction(unit, "player") > 4 then
        healthBar:SetStatusBarColor(GREEN_FONT_COLOR:GetRGB())
    else
        healthBar:SetStatusBarColor(UnitSelectionColor(unit))
    end
end

function MTUI:InitializeUnitframes()
    options = self.db.global

    hooksecurefunc("PlayerFrame_ToPlayerArt", TweakPlayerFrame)
    hooksecurefunc("PlayerFrame_ToVehicleArt", TweakVehicleFrame)
    hooksecurefunc("TargetFrame_CheckClassification", TweakTargetFrame)
    hooksecurefunc("UnitFrameHealthBar_Update", ColorizeHealthbar)
    hooksecurefunc("HealthBar_OnValueChanged", function(self) ColorizeHealthbar(self, self.unit) end)
end
