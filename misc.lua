local MTUI = LibStub("AceAddon-3.0"):GetAddon("MTUI")

local function moveFrame(Frame, a, b, c, d, e)
    Frame:SetMovable(true)
    Frame:ClearAllPoints()
    Frame:SetPoint(a, b, c, d, e)
    Frame:SetUserPlaced(true)
    Frame:SetMovable(false)
end

function MTUI:MoveFrames()
    local Y = self.db.global.unitframeOffsetY
    local X = self.db.global.unitframeOffsetX / 2

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
    local texture = self.db.global.barTexture

    local UnitFrames = {
        PlayerFrame, PlayerFrameManaBar, PlayerFrameAlternateManaBar, PlayerFrameMyHealPredictionBar,
        TargetFrame, TargetFrameToT, FocusFrame, FocusFrameToT, PetFrame,
        PartyMemberFrame1, PartyMemberFrame2, PartyMemberFrame3, PartyMemberFrame4,
        Boss1TargetFrame, Boss2TargetFrame, Boss3TargetFrame, Boss4TargetFrame, Boss5TargetFrame,
    }

    local UnitFrameRegions = {
        "healthbar", "spellbar", "healAbsorbBar", "totalAbsorbBar",
        "AnimatedLossBar", "myHealPredictionBar", "otherHealPredictionBar",
        "manabar", "myManaCostPredictionBar",
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

    GameTooltipStatusBar:SetStatusBarTexture(texture)
    GameTooltipStatusBar:SetHeight(6)

    CastingBarFrame:SetStatusBarTexture(texture)
    for _, frame in next, { MirrorTimer1, MirrorTimer2, MirrorTimer3 } do
        _G[frame:GetName().."StatusBar"]:SetStatusBarTexture(texture)
    end

    PlayerFrame.healthbar.AnimatedLossBar:SetStatusBarTexture(texture)

    -- Skin power bars with special textures
    -- hooksecurefunc("UnitFrameManaBar_UpdateType", function(self)
    --     local powerType, powerToken, altR, altG, altB = UnitPowerType(self.unit)
    --     local info = PowerBarColor[powerToken]
    --     self:SetStatusBarTexture(texture)
    --     if PlayerFrameAlternateManaBar then
    --         PlayerFrameAlternateManaBar:SetStatusBarTexture(texture)
    --     end
    --     if info and info.atlas then
    --         self:SetStatusBarColor(info.r, info.g, info.b)
    --         if self.FeedbackFrame then
    --             self.FeedbackFrame.BarTexture:SetTexture(texture)
    --             self.FeedbackFrame.BarTexture:SetVertexColor(info.r, info.g, info.b)
    --         end
    --     end
    -- end)
end

function MTUI:ApplyCastingbarTweaks()
    local CB_HEIGHT = 16
    local CB_PADDING = 3
    CastingBarFrame:SetHeight(CB_HEIGHT)
    CastingBarFrame.Text:SetAllPoints(CastingBarFrame)
    CastingBarFrame.Text:SetScale(0.9)
    CastingBarFrame.Border:Hide()
    local Backdrop = CreateFrame("FRAME", nil, CastingBarFrame)
    Backdrop:ClearAllPoints()
    Backdrop:SetPoint("TOPLEFT", CastingBarFrame, "TOPLEFT", -CB_PADDING, CB_PADDING)
    Backdrop:SetPoint("TOPRIGHT", CastingBarFrame, "TOPRIGHT", CB_PADDING, CB_PADDING)
    Backdrop:SetHeight(CB_HEIGHT + CB_PADDING * 2)
    Backdrop:SetBackdrop({
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 16,
    })
end

function MTUI:RemoveAnnoyances()
    -- Hide annoying alerts
    function MainMenuMicroButton_AreAlertsEffectivelyEnabled()
        return false
    end
end
