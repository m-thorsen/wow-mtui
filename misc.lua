local MTUI = LibStub("AceAddon-3.0"):GetAddon("MTUI")

local function moveFrame(Frame, a, b, c, d, e)
    Frame:SetMovable(true)
    Frame:ClearAllPoints()
    Frame:SetPoint(a, b, c, d, e)
    Frame:SetUserPlaced(true)
    Frame:SetMovable(false)
end

function MTUI:MoveFrames()
    local Y = self.db.profile.unitframeOffsetY
    local X = self.db.profile.unitframeOffsetX / 2

    moveFrame(PlayerFrame, "BOTTOMRIGHT", UIParent, "BOTTOM", -X, Y)
    moveFrame(TargetFrame, "BOTTOMLEFT", UIParent, "BOTTOM", X, Y)
    moveFrame(FocusFrame, "BOTTOMLEFT", TargetFrame, "TOPRIGHT", -50, 20)
    moveFrame(CompactRaidFrameContainer, "TOPLEFT", TargetFrame, "TOPRIGHT", 0, -20)
    moveFrame(UIWidgetTopCenterContainerFrame, "TOP", UIParent, "TOP", 0, -5)
    moveFrame(PlayerPowerBarAlt, "TOP", UIParent, "TOP", 0, -100)
    moveFrame(ObjectiveTrackerFrame, "TOPLEFT", UIParent, "TOPLEFT", 30, -5)

    ObjectiveTrackerFrame.HeaderMenu.Title:SetPoint("TOPLEFT", ObjectiveTrackerFrame, "TOPLEFT", -6, -7)
    ObjectiveTrackerFrame.HeaderMenu.Title:SetJustifyH("LEFT")
    ObjectiveTrackerFrame:SetHeight(800)
end

function MTUI:ApplyBarTexture()
    local texture = self.db.profile.mediaPath..self.db.profile.barTexture

    local UnitFrames = {
        PlayerFrame, PlayerFrameManaBar, PlayerFrameAlternateManaBar, PlayerFrameMyHealPredictionBar,
        TargetFrame, TargetFrameToT, FocusFrame, FocusFrameToT, PetFrame,
    }

    for i = 1, 4 do
        table.insert(UnitFrames, "PartyMemberFrame"..i)
    end

    for i = 1, MAX_BOSS_FRAMES do
        table.insert(UnitFrames, "Boss"..i.."TargetFrame")
    end

    local UnitFrameRegions = {
        "healthbar", "manabar", "spellbar", "healAbsorbBar", "totalAbsorbBar",
        "AnimatedLossBar", "myHealPredictionBar", "otherHealPredictionBar", "myManaCostPredictionBar",
    }

    for _, frame in next, UnitFrames do
        for _, region in next, UnitFrameRegions do
            local bar = frame[region]
            if bar and bar.SetStatusBarTexture then
                bar:SetStatusBarTexture(texture)
            elseif bar and bar.SetTexture then
                bar:SetTexture(texture)
            end
        end
    end

    CastingBarFrame:SetStatusBarTexture(texture)
    for _, frame in next, { MirrorTimer1, MirrorTimer2, MirrorTimer3 } do
        _G[frame:GetName().."StatusBar"]:SetStatusBarTexture(texture)
    end

    PlayerFrame.healthbar.AnimatedLossBar:SetStatusBarTexture(texture)

    hooksecurefunc("UnitFrameManaBar_UpdateType", function(self)
        local powerType, powerToken, altR, altG, altB = UnitPowerType(self.unit)
        local info = PowerBarColor[powerToken]
        self:SetStatusBarTexture(texture)
        if PlayerFrameAlternateManaBar then
            PlayerFrameAlternateManaBar:SetStatusBarTexture(texture)
        end
        if info and info.atlas then
            self:SetStatusBarColor(info.r, info.g, info.b)
            if self.FeedbackFrame then
                self.FeedbackFrame.BarTexture:SetTexture(texture)
                self.FeedbackFrame.BarTexture:SetVertexColor(info.r, info.g, info.b)
            end
        end
    end)
end

function MTUI:SkinCastingBar()
    local CB_HEIGHT = 16
    local Backdrop = CreateFrame("FRAME", nil, CastingBarFrame)
    CastingBarFrame:SetHeight(CB_HEIGHT)
    CastingBarFrame.Text:SetAllPoints(CastingBarFrame)
    CastingBarFrame.Border:Hide()
    Backdrop:ClearAllPoints()
    Backdrop:SetPoint("TOPLEFT", CastingBarFrame, "TOPLEFT", -3, 2)
    Backdrop:SetPoint("TOPRIGHT", CastingBarFrame, "TOPRIGHT", 2, 2)
    Backdrop:SetHeight(20)
    Backdrop:SetBackdrop({
        edgeFile = "Interface/Glues/COMMON/TextPanel-Border",
        edgeSize = 10,
    });
    -- CastingBarFrame.Border:SetTexture([[Interface\CastingBar\UI-CastingBar-Border-Small]])
    -- CastingBarFrame.Border:SetPoint("TOPLEFT", -35, 30)
    -- CastingBarFrame.Border:SetPoint("BOTTOMRIGHT", 35, -30)
end

function MTUI:RemoveAnnoyances()
    -- Hide annoying alerts
    function MainMenuMicroButton_AreAlertsEffectivelyEnabled()
        return false
    end
end
