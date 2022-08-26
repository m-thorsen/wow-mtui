local eventFrame = CreateFrame("Frame", "MT_Layout", UIParent);

local options = {
    unitframePosition   = 200, -- from bottom
    unitframeSpacing    = 125, -- from horizontal center
};

local TorghastBuffs = ScenarioBlocksFrame.MawBuffsBlock.Container;

local function MoveFrame(self, frameAnchor, parent, parentAnchor, deltaX, deltaY)
    self:SetMovable(true);
    self:ClearAllPoints();
    self:SetPoint(frameAnchor, parent, parentAnchor, deltaX, deltaY);
    self:SetUserPlaced(true);
    self:SetMovable(false);
end;

eventFrame:RegisterEvent("ADDON_LOADED");
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if (event == "ADDON_LOADED" and addonName == 'MT_UI') then
        -- center unit frames
        MoveFrame(PlayerFrame, "BOTTOMRIGHT", UIParent, "BOTTOM", -options.unitframeSpacing, options.unitframePosition);
        MoveFrame(TargetFrame, "BOTTOMLEFT", UIParent, "BOTTOM", options.unitframeSpacing, options.unitframePosition);
        MoveFrame(FocusFrame, "BOTTOMLEFT", TargetFrame, "TOPRIGHT", -50, 20);
        MoveFrame(CastingBarFrame, "TOP", UIParent, "BOTTOM", 0, options.unitframePosition);
        MoveFrame(PlayerPowerBarAlt, "TOP", UIParent, "TOP", 0, -100);

        -- move the quest tracker
        MoveFrame(ObjectiveTrackerFrame, "TOPLEFT", UIParent, "TOPLEFT", 32, -8);
        ObjectiveTrackerFrame.HeaderMenu.Title:SetPoint("TOPLEFT", ObjectiveTrackerFrame, "TOPLEFT", -6, -7);
        ObjectiveTrackerFrame.HeaderMenu.Title:SetJustifyH("LEFT");
        ObjectiveTrackerFrame:SetHeight(800);

        -- make the torghast buff tracker pop out to the right
        MoveFrame(TorghastBuffs.List, "TOPLEFT", TorghastBuffs, "TOPRIGHT", 0, 0);
        MoveFrame(UIWidgetTopCenterContainerFrame, "TOP", UIParent, "TOP", 0, -5);
        MinimapZoneText:SetWidth(120);
    end;
end);
