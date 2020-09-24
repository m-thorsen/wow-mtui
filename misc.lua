local MTUI = LibStub("AceAddon-3.0"):GetAddon("MTUI");

function MTUI:MoveFrames()
    local function moveFrame(frame, a, b, c, d, e)
        frame:SetMovable(true);
        frame:ClearAllPoints();
        frame:SetPoint(a, b, c, d, e);
        frame:SetUserPlaced(true);
        frame:SetMovable(false);
    end;

    local Y = self.db.global.unitframeOffsetY;
    local X = self.db.global.unitframeOffsetX / 2;

    moveFrame(PlayerFrame, "BOTTOMRIGHT", UIParent, "BOTTOM", -X, Y);
    moveFrame(TargetFrame, "BOTTOMLEFT", UIParent, "BOTTOM", X, Y);
    moveFrame(FocusFrame, "BOTTOMLEFT", TargetFrame, "TOPRIGHT", -50, 20);
    moveFrame(CompactRaidFrameContainer, "TOPLEFT", TargetFrame, "TOPRIGHT", 0, -20);
    moveFrame(UIWidgetTopCenterContainerFrame, "TOP", UIParent, "TOP", 0, -5);
    moveFrame(PlayerPowerBarAlt, "TOP", UIParent, "TOP", 0, -100);
    moveFrame(ObjectiveTrackerFrame, "TOPLEFT", UIParent, "TOPLEFT", 30, -5);
    moveFrame(CastingBarFrame, "BOTTOM", UIParent, "BOTTOM", 0, 183);

    ObjectiveTrackerFrame.HeaderMenu.Title:SetPoint("TOPLEFT", ObjectiveTrackerFrame, "TOPLEFT", -6, -7);
    ObjectiveTrackerFrame.HeaderMenu.Title:SetJustifyH("LEFT");
    ObjectiveTrackerFrame:SetHeight(800);
end;

function MTUI:ApplyBarTexture()
    local texture = self.db.global.barTexture;
    local UnitFrames = {
        PlayerFrame, PlayerFrameManaBar, PlayerFrameAlternateManaBar, PlayerFrameMyHealPredictionBar,
        TargetFrame, TargetFrameToT, FocusFrame, FocusFrameToT, PetFrame,
        PartyMemberFrame1, PartyMemberFrame2, PartyMemberFrame3, PartyMemberFrame4,
        Boss1TargetFrame, Boss2TargetFrame, Boss3TargetFrame, Boss4TargetFrame, Boss5TargetFrame,
    };
    local UnitFrameRegions = {
        "healthbar", "spellbar", "healAbsorbBar", "totalAbsorbBar",
        "AnimatedLossBar", "myHealPredictionBar", "otherHealPredictionBar",
        "manabar", "myManaCostPredictionBar",
    };

    for _, frame in next, UnitFrames do
        for _, region in next, UnitFrameRegions do
            local bar = frame[region];
            if bar and bar.SetStatusBarTexture then
                bar:SetStatusBarTexture(texture);
            elseif bar and bar.SetTexture then
                bar:SetTexture(texture);
            end;
        end;
    end;

    GameTooltipStatusBar:SetStatusBarTexture(self.db.global.namePlateTexture);
    GameTooltipStatusBar:SetHeight(5);

    CastingBarFrame:SetStatusBarTexture(texture);
    for _, frame in next, { MirrorTimer1, MirrorTimer2, MirrorTimer3 } do
        _G[frame:GetName().."StatusBar"]:SetStatusBarTexture(texture);
    end;

    PlayerFrame.healthbar.AnimatedLossBar:SetStatusBarTexture(texture);

    hooksecurefunc("UnitFrameManaBar_UpdateType", function(self)
        self:SetStatusBarTexture(texture);
        if PlayerFrameAlternateManaBar then
            PlayerFrameAlternateManaBar:SetStatusBarTexture(texture);
        end;

        -- Skin power bars with special textures
        local powerType, powerToken, altR, altG, altB = UnitPowerType(self.unit);
        local info = PowerBarColor[powerToken];
        if info and info.atlas then
            self:SetStatusBarColor(info.r, info.g, info.b);
            if self.FeedbackFrame then
                self.FeedbackFrame.BarTexture:SetTexture(texture);
                self.FeedbackFrame.BarTexture:SetVertexColor(info.r, info.g, info.b);
            end;
        end;
    end);
end;

function MTUI:ApplyCastingbarTweaks()
    CastingBarFrame:SetSize(200, 16)
    CastingBarFrame.Text:SetScale(0.95)
    CastingBarFrame.Text:SetPoint("TOP")
    CastingBarFrame.Border:Hide()
    CastingBarFrame.Flash:SetTexture(nil)
    CastingBarFrame:SetFrameStrata("TOOLTIP")

    local LeftBorder = CastingBarFrame:CreateTexture(nil, "ARTWORK")
    LeftBorder:SetPoint("TOPLEFT", CastingBarFrame, "TOPLEFT", -6, 4)
    LeftBorder:SetSize(106, 24)
    LeftBorder:SetTexture("Interface/PaperDollInfoFrame/UI-Character-Skills-BarBorder")
    LeftBorder:SetTexCoord(0, 0.4, 0.2, 0.8)

    local RightBorder = CastingBarFrame:CreateTexture(nil, "ARTWORK")
    RightBorder:SetPoint("TOPRIGHT", CastingBarFrame, "TOPRIGHT", 6, 4)
    RightBorder:SetSize(106, 24)
    RightBorder:SetTexture("Interface/PaperDollInfoFrame/UI-Character-Skills-BarBorder")
    RightBorder:SetTexCoord(0.4, 0, 0.2, 0.8)
end

function MTUI:RemoveAnnoyances()
    -- Hide annoying alerts
    function MainMenuMicroButton_AreAlertsEffectivelyEnabled()
        return false
    end
end
