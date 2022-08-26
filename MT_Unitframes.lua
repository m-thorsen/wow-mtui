local eventFrame = CreateFrame("Frame", "MT_Unitframes", UIParent);

local options = {
    localMediaDir = "Interface/Addons/MT_UI/Media/",
};

local function LocalTexture(name)
    return options.localMediaDir .. name;
end;

local function ApplyCommonFrameTweaks(self)
    self.name:ClearAllPoints();
    self.healthbar:ClearAllPoints();
    self.healthbar:SetHeight(28);
    self.healthbar.LeftText:SetPoint("LEFT", self.healthbar, "LEFT", 3, 0);
    self.healthbar.RightText:SetPoint("RIGHT", self.healthbar, "RIGHT", -3, 0);
    self.healthbar.TextString:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0);
end;

local function GetUnitColor(unit)
    if (UnitIsTapDenied(unit) or not UnitIsConnected(unit)) then
        return GRAY_FONT_COLOR:GetRGB();
    elseif (UnitIsPlayer(unit) and UnitClass(unit)) then
        return GetClassColor(select(2, UnitClass(unit)));
    elseif (UnitReaction(unit, "player") and UnitReaction(unit, "player") > 4) then
        return GREEN_FONT_COLOR:GetRGB();
    end;

    return UnitSelectionColor(unit, true);
end;

local function SetHealthbarColor(bar)
    if (UnitExists(bar.unit)) then
        bar:SetStatusBarColor(GetUnitColor(bar.unit));
    end;
end;

local function TweakPlayerFrame(self)
    PlayerStatusTexture:ClearAllPoints();
    PlayerStatusTexture:SetPoint("CENTER", PlayerFrame, "CENTER",16, 8);
    PlayerStatusTexture:SetTexture(LocalTexture("Player-Status"));
    PlayerStatusTexture:SetWidth(192);
    PlayerFrameTexture:SetTexture(LocalTexture("TargetFrame"));
    ApplyCommonFrameTweaks(self);
    self.healthbar:SetPoint("TOPRIGHT", -5, -24);
    self.healthbar.AnimatedLossBar:SetAlpha(0.1);
    self.name:Hide();
    self.name:SetPoint("CENTER", frame, "CENTER", 50.5, 36);
end;

local function TweakVehicleFrame(self, vehicle)
    if (vehicle == "Natural") then
        PlayerFrameVehicleTexture:SetTexture("Interface/Vehicles/UI-Vehicle-Frame-Organic");
        PlayerFrameFlash:SetTexture("Interface/Vehicles/UI-Vehicle-Frame-Organic-Flash");
        PlayerFrameFlash:SetTexCoord(-0.02, 1, 0.07, 0.86);
        self.healthbar:SetSize(103, 12);
        self.healthbar:SetPoint("TOPRIGHT", -15, -41);
    else
        PlayerFrameVehicleTexture:SetTexture("Interface/Vehicles/UI-Vehicle-Frame");
        PlayerFrameFlash:SetTexture("Interface/Vehicles/UI-Vehicle-Frame-Flash");
        PlayerFrameFlash:SetTexCoord(-0.02, 1, 0.07, 0.86);
        self.healthbar:SetSize(100, 12);
        self.healthbar:SetPoint("TOPRIGHT", -15, -41);
    end;
    PlayerName:SetPoint("CENTER", 50, 23);
    PlayerFrameBackground:SetWidth(114);
end;


local function TweakTargetFrame(frame)
    local type = UnitClassification(frame.unit);
    frame.nameBackground:Hide();
    if (not frame.texture) then
        local tex = frame:CreateTexture(nil, "BACKGROUND");
        tex:SetTexture(LocalTexture("TargetingFrameShadow"));
        tex:SetPoint("TOPLEFT", frame, "TOPLEFT", -25, 16);
        tex:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 20, 0);
        frame.texture = tex;
    end
    ApplyCommonFrameTweaks(frame);
    frame.threatNumericIndicator:SetPoint("BOTTOM", PlayerFrame, "TOP", 72, -21);
    frame.deadText:SetPoint("CENTER", frame.healthbar, "CENTER", 0, 0);
    frame.deadText:SetTextColor(0.5, 0.5, 0.5);
    frame.healthbar:ClearAllPoints();
    frame.Background:SetPoint("TOP", frame.healthbar, "TOP", 0, 0);
    if (type == "minus") then
        frame.texture:Hide();
        frame.name:SetPoint("LEFT", frame, 16, 17);
        frame.healthbar:SetPoint("LEFT", 5, 3);
        frame.healthbar:SetHeight(12);
        frame.Background:SetHeight(12);
        if (frame.threatIndicator) then
            frame.threatIndicator:SetTexture("Interface/TargetingFrame/UI-TargetingFrame-Minus-Flash");
            frame.threatIndicator:SetTexCoord(0, 1, 0, 1);
            frame.threatIndicator:SetWidth(256);
            frame.threatIndicator:SetHeight(128);
            frame.threatIndicator:SetPoint("TOPLEFT", frame, "TOPLEFT", -24, 0);
        end;
    else
        frame.texture:Show();
        frame.name:SetPoint("LEFT", frame, 15, 36);
        frame.healthbar:SetPoint("TOPLEFT", 5, -24);
        frame.Background:SetHeight(40);
        if (type == "worldboss" or type == "elite") then
            frame.borderTexture:SetTexture(LocalTexture("TargetFrame-Elite"));
        elseif (type == "rareelite") then
            frame.borderTexture:SetTexture(LocalTexture("TargetFrame-RareElite"));
        elseif (type == "rare") then
            frame.borderTexture:SetTexture(LocalTexture("TargetFrame-Rare"));
        else
            frame.borderTexture:SetTexture(LocalTexture("TargetFrame"));
        end;
        if (frame.threatIndicator) then
            frame.threatIndicator:SetTexCoord(0, 0.9453125, 0, 0.181640625);
            frame.threatIndicator:SetWidth(242);
            frame.threatIndicator:SetHeight(93);
            frame.threatIndicator:SetPoint("TOPLEFT", frame, "TOPLEFT", -24, 0);
        end;
    end;
end;

local function SetStatusbarTexture()
    local frames = {
        PlayerFrame, PlayerFrameManaBar, PlayerFrameAlternateManaBar, PlayerFrameMyHealPredictionBar,
        TargetFrame, TargetFrameToT, FocusFrame, FocusFrameToT, PetFrame,
        PartyMemberFrame1, PartyMemberFrame2, PartyMemberFrame3, PartyMemberFrame4,
        Boss1TargetFrame, Boss2TargetFrame, Boss3TargetFrame, Boss4TargetFrame, Boss5TargetFrame,
    };

    local regions = {
        "healthbar", "spellbar", "healAbsorbBar", "totalAbsorbBar",
        "AnimatedLossBar", "myHealPredictionBar", "otherHealPredictionBar",
        "manabar", "myManaCostPredictionBar",
    };

    for _, frame in next, frames do
        for _, region in next, regions do
            local bar = frame[region];

            if (bar and bar.SetStatusBarTexture) then
                bar:SetStatusBarTexture(LocalTexture("statusbar"));
            elseif (bar and bar.SetTexture) then
                bar:SetTexture(LocalTexture("statusbar"));
            end;
        end;
    end;
end;

eventFrame:RegisterEvent("ADDON_LOADED");
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if (event == "ADDON_LOADED" and addonName == 'MT_UI') then
        hooksecurefunc("PlayerFrame_ToPlayerArt", TweakPlayerFrame);
        hooksecurefunc("PlayerFrame_ToVehicleArt", TweakVehicleFrame);
        hooksecurefunc("TargetFrame_CheckClassification", TweakTargetFrame);
        hooksecurefunc("UnitFrameHealthBar_Update", SetHealthbarColor);
        hooksecurefunc("HealthBar_OnValueChanged", SetHealthbarColor);
        SetStatusbarTexture();
    end;
end);


-- @hack: Revert global playerframe_updateart because of error...
function PlayerFrame_UpdateArt(self)
	if (self.inSeat) then
        PlayerFrame_SequenceFinished(PlayerFrame);
		if (UnitHasVehiclePlayerFrameUI("player")) then
			PlayerFrame_ToVehicleArt(self, UnitVehicleSkin("player"));
		else
			PlayerFrame_ToPlayerArt(self);
		end
	elseif (self.updatePetFrame) then
		self.updatePetFrame = false;
		PetFrame_Update(PetFrame);
	end
end

