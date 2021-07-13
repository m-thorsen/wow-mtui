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

local tex = MTUI.textures.statusbar;

function MTUI:InitStatusbars()
    for _, frame in next, UnitFrames do
        for _, region in next, UnitFrameRegions do
            local bar = frame[region];

            if (bar and bar.SetStatusBarTexture) then
                bar:SetStatusBarTexture(tex);
            elseif (bar and bar.SetTexture) then
                bar:SetTexture(tex);
            end;
        end;
    end;
end;

function MTUI:InitMinorStatusbars()
    GameTooltipStatusBar:SetStatusBarTexture(tex);
    GameTooltipStatusBar:SetHeight(5);

    CastingBarFrame:SetStatusBarTexture(tex);
    for _, frame in next, { MirrorTimer1, MirrorTimer2, MirrorTimer3 } do
        _G[frame:GetName().."StatusBar"]:SetStatusBarTexture(tex);
    end;

    PlayerFrame.healthbar.AnimatedLossBar:SetStatusBarTexture(tex);

    hooksecurefunc("UnitFrameManaBar_UpdateType", function(frame)
        frame:SetStatusBarTexture(tex);

        if (PlayerFrameAlternateManaBar) then
            PlayerFrameAlternateManaBar:SetStatusBarTexture(tex);
        end;

        -- Skin power bars with special textures
        local powerType, powerToken, altR, altG, altB = UnitPowerType(frame.unit);
        local info = PowerBarColor[powerToken];

        if (info and info.atlas) then
            frame:SetStatusBarColor(info.r, info.g, info.b);

            if (frame.FeedbackFrame) then
                frame.FeedbackFrame.BarTexture:SetTexture(tex);
                frame.FeedbackFrame.BarTexture:SetVertexColor(info.r, info.g, info.b);
            end;
        end;
    end);
end;
