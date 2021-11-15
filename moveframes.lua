local function moveObjectiveTracker()
    -- attach the quest tracker to the minimap to allow broker bars etc to adjust frames
    MTUI:moveFrame(ObjectiveTrackerFrame, "TOPLEFT", MinimapCluster, "TOPRIGHT", -(GetScreenWidth() - 30), -5);
    ObjectiveTrackerFrame.HeaderMenu.Title:SetPoint("TOPLEFT", ObjectiveTrackerFrame, "TOPLEFT", -6, -7);
    ObjectiveTrackerFrame.HeaderMenu.Title:SetJustifyH("LEFT");
    ObjectiveTrackerFrame:SetHeight(800);

    -- make the torghast buff tracker pop out to the right
    local TorghastBuffs = ScenarioBlocksFrame.MawBuffsBlock.Container;
    MTUI:moveFrame(TorghastBuffs.List, "TOPLEFT", TorghastBuffs, "TOPRIGHT", 0, 0);
end;

function MTUI:InitMoveFrames()
    moveObjectiveTracker();
    MTUI:moveFrame(UIWidgetTopCenterContainerFrame, "TOP", UIParent, "TOP", 0, -5);
    MinimapZoneText:SetWidth(120);
end;
