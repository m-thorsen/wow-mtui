local MTUI = LibStub("AceAddon-3.0"):GetAddon("MTUI");

local function moveFrame(frame, frameAnchor, parent, parentAnchor, deltaX, deltaY)
    frame:SetMovable(true);
    frame:ClearAllPoints();
    frame:SetPoint(frameAnchor, parent, parentAnchor, deltaX, deltaY);
    frame:SetUserPlaced(true);
    frame:SetMovable(false);
end;

local function moveObjectiveTracker()
    moveFrame(ObjectiveTrackerFrame, "TOPLEFT", UIParent, "TOPLEFT", 35, -10);
    ObjectiveTrackerFrame.HeaderMenu.Title:SetPoint("TOPLEFT", ObjectiveTrackerFrame, "TOPLEFT", -6, -7);
    ObjectiveTrackerFrame.HeaderMenu.Title:SetJustifyH("LEFT");
    ObjectiveTrackerFrame:SetHeight(800);

    local TorghastBuffs = ScenarioBlocksFrame.MawBuffsBlock.Container;
    moveFrame(TorghastBuffs.List, "TOPLEFT", TorghastBuffs, "TOPRIGHT", 0, 0);
    -- TorghastBuffs:GetPushedTexture():SetTexCoord(1, 0, 0, 1)
end;

local function cleanupMinimap()
    MinimapZoneTextButton:Hide();
    MinimapBorderTop:Hide();
    MiniMapWorldMapButton:Hide();

    moveFrame(MinimapCluster, "TOPRIGHT", UIParent, "TOPRIGHT", -5, 15);
    moveFrame(BuffFrame, "TOPRIGHT", MinimapCluster, "TOPLEFT", -10, -25);
    BuffFrame.ClearAllPoints = function() end;
    BuffFrame.SetPoint = function() end;
end;

local function moveUnitFrames()
    local Y = MTUI.db.global.unitframeOffsetY;
    local X = MTUI.db.global.unitframeOffsetX / 2;

    moveFrame(PlayerFrame, "BOTTOMRIGHT", UIParent, "BOTTOM", -X, Y);
    moveFrame(TargetFrame, "BOTTOMLEFT", UIParent, "BOTTOM", X, Y);
    moveFrame(FocusFrame, "BOTTOMLEFT", TargetFrame, "TOPRIGHT", -50, 20);
    moveFrame(CastingBarFrame, "TOP", UIParent, "BOTTOM", 0, Y);
    moveFrame(CompactRaidFrameContainer, "TOPLEFT", TargetFrame, "TOPRIGHT", 0, -20);
    moveFrame(PlayerPowerBarAlt, "TOP", UIParent, "TOP", 0, -100);
end;

function MTUI:InitMoveFrames()
    moveObjectiveTracker();
    cleanupMinimap();
    moveUnitFrames();
    moveFrame(UIWidgetTopCenterContainerFrame, "TOP", UIParent, "TOP", 0, -5);
end;
