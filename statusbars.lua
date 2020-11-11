local MTUI = LibStub("AceAddon-3.0"):GetAddon("MTUI");

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

function MTUI:InitStatusbars()
    local texture = self.db.global.statusbarTexture;

    for _, frame in next, UnitFrames do
        for _, region in next, UnitFrameRegions do
            local bar = frame[region];

            if (bar and bar.SetStatusBarTexture) then
                bar:SetStatusBarTexture(texture);
            elseif (bar and bar.SetTexture) then
                bar:SetTexture(texture);
            end;
        end;
    end;

    if (self.db.global.enableMinorStatusbars) then
        GameTooltipStatusBar:SetStatusBarTexture(texture);
        GameTooltipStatusBar:SetHeight(5);

        CastingBarFrame:SetStatusBarTexture(texture);
        for _, frame in next, { MirrorTimer1, MirrorTimer2, MirrorTimer3 } do
            _G[frame:GetName().."StatusBar"]:SetStatusBarTexture(texture);
        end;

        PlayerFrame.healthbar.AnimatedLossBar:SetStatusBarTexture(texture);

        hooksecurefunc("UnitFrameManaBar_UpdateType", function(frame)
            frame:SetStatusBarTexture(texture);

            if (PlayerFrameAlternateManaBar) then
                PlayerFrameAlternateManaBar:SetStatusBarTexture(texture);
            end;

            -- Skin power bars with special textures
            local powerType, powerToken, altR, altG, altB = UnitPowerType(frame.unit);
            local info = PowerBarColor[powerToken];

            if (info and info.atlas) then
                frame:SetStatusBarColor(info.r, info.g, info.b);

                if (frame.FeedbackFrame) then
                    frame.FeedbackFrame.BarTexture:SetTexture(texture);
                    frame.FeedbackFrame.BarTexture:SetVertexColor(info.r, info.g, info.b);
                end;
            end;
        end);
    end;
end;
