local function moveFrame(frame, frameAnchor, parent, parentAnchor, deltaX, deltaY)
    frame:SetMovable(true);
    frame:ClearAllPoints();
    frame:SetPoint(frameAnchor, parent, parentAnchor, deltaX, deltaY);
    frame:SetUserPlaced(true);
    frame:SetMovable(false);
end;

local function moveObjectiveTracker()
    -- attach the quest tracker to the minimap to allow broker bars etc to adjust frames
    moveFrame(ObjectiveTrackerFrame, "TOPLEFT", MinimapCluster, "TOPRIGHT", -(GetScreenWidth() - 30), -5);
    ObjectiveTrackerFrame.HeaderMenu.Title:SetPoint("TOPLEFT", ObjectiveTrackerFrame, "TOPLEFT", -6, -7);
    ObjectiveTrackerFrame.HeaderMenu.Title:SetJustifyH("LEFT");
    ObjectiveTrackerFrame:SetHeight(800);

    -- make the torghast buff tracker pop out to the right
    local TorghastBuffs = ScenarioBlocksFrame.MawBuffsBlock.Container;
    moveFrame(TorghastBuffs.List, "TOPLEFT", TorghastBuffs, "TOPRIGHT", 0, 0);
end;

local function moveUnitFrames()
    local Y = MTUI.unitframes.offsetY;
    local X = MTUI.unitframes.offsetX / 2;

    moveFrame(PlayerFrame, "BOTTOMRIGHT", UIParent, "BOTTOM", -X, Y);
    moveFrame(TargetFrame, "BOTTOMLEFT", UIParent, "BOTTOM", X, Y);
    moveFrame(FocusFrame, "BOTTOMLEFT", TargetFrame, "TOPRIGHT", -50, 20);
    moveFrame(CastingBarFrame, "TOP", UIParent, "BOTTOM", 0, Y);
    moveFrame(CompactRaidFrameContainer, "TOPLEFT", TargetFrame, "TOPRIGHT", 0, -20);
    moveFrame(PlayerPowerBarAlt, "TOP", UIParent, "TOP", 0, -100);
end;

function MTUI:InitMoveFrames()
    moveObjectiveTracker();
    moveUnitFrames();
    moveFrame(UIWidgetTopCenterContainerFrame, "TOP", UIParent, "TOP", 0, -5);
    MinimapZoneText:SetWidth(120);
end;
