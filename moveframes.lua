local function moveObjectiveTracker()
    -- reattach the buff frame to compensate for removal of the minimap zone text
    MTUI:moveFrame(BuffFrame, "TOPLEFT", UIParent, "TOPLEFT", 35, -13);

    -- move the tracker
    MTUI:moveFrame(ObjectiveTrackerFrame, "TOPLEFT", UIParent, "TOPLEFT", 32, -8);
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
