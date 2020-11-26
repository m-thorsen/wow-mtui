local MTUI = LibStub("AceAddon-3.0"):GetAddon("MTUI");

local function moveFrame(frame, frameAnchor, parent, parentAnchor, deltaX, deltaY)
    frame:SetMovable(true);
    frame:ClearAllPoints();
    frame:SetPoint(frameAnchor, parent, parentAnchor, deltaX, deltaY);
    frame:SetUserPlaced(true);
    frame:SetMovable(false);
end;

function MTUI:InitMoveFrames()
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

    local TorghastBuffs = ScenarioBlocksFrame.MawBuffsBlock.Container;
    moveFrame(TorghastBuffs.List, "TOPLEFT", TorghastBuffs, "TOPRIGHT", 0, 0);

    -- TorghastBuffs:GetPushedTexture():SetTexCoord(1, 0, 0, 1)
end;
