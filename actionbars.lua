local MTUI = LibStub("AceAddon-3.0"):GetAddon("MTUI");

-- Create a container frame
local actionbarFrame = CreateFrame("Frame", nil, UIParent);

-- Initialize options
local btnSpacing, btnSize, btnSizeSmall, barWidth, petBarWidth, trackerHeight, edgeOffset;

-- Update options
local function LoadOptions()
    btnSize       = 36;
    btnSizeSmall  = 30; -- pet, stance etc
    trackerHeight = MTUI.db.global.actionbarTrackHeight;
    btnSpacing    = MTUI.db.global.actionbarBtnSpacing + 4;
    barWidth      = (btnSize + btnSpacing) * NUM_MULTIBAR_BUTTONS - btnSpacing;
    petBarWidth   = (btnSizeSmall + btnSpacing) * NUM_PET_ACTION_SLOTS - btnSpacing;
    edgeOffset    = btnSpacing - 3;
end;

-- Hide artwork
local function HideArtwork()
    if InCombatLockdown() then return end;

    for _, f in next, {
        ActionBarUpButton, ActionBarDownButton, OverrideActionBarEndCapL, OverrideActionBarEndCapR,
        MainMenuBarArtFrame.PageNumber, MainMenuBarArtFrame.LeftEndCap, MainMenuBarArtFrame.RightEndCap,
        MainMenuBarArtFrameBackground, MainMenuBarBackpackButton, MainMenuBarPerformanceBar,
        MicroButtonAndBagsBar.MicroBagBar
    } do f:Hide() end;
    for i = 0, 3 do _G["CharacterBag"..i.."Slot"]:Hide() end;
    for i = 1, 2 do _G["PossessBackground"..i]:SetTexture(nil) end;
    for i = 0, 1 do _G["SlidingActionBarTexture"..i]:SetTexture(nil) end;
    for _, tex in next, { StanceBarLeft, StanceBarMiddle, StanceBarRight } do tex:SetTexture(nil) end;
end;

-- Some action buttons are untextured as they are normally in front of the main menu artwork
local function FixUntexturedButtons()
    local hiddenButtons = {};

    for i = 1, 12 do
        tinsert(hiddenButtons, _G["ActionButton"..i]);
    end;

    for i = 1, 6 do
        tinsert(hiddenButtons, _G["MultiBarBottomRightButton"..i]);
    end;

    for _, b in next, hiddenButtons do
        b.noGrid = nil;
        b:Show();
        b.NormalTexture:SetAlpha(0.5);
        if not b.floatingBG and not _G[b:GetName().."FloatingBG"] then
            b.floatingBG = b:CreateTexture();
            b.floatingBG:SetPoint("TOPLEFT", b, -15, 15);
            b.floatingBG:SetPoint("BOTTOMRIGHT", b, 15, -15);
            b.floatingBG:SetTexture("Interface/Buttons/UI-Quickslot");
            b.floatingBG:SetAlpha(0.4);
            b.floatingBG:SetDrawLayer("BACKGROUND", -1);
        end;
    end;

    -- Show/hide these buttons' grid when appropriate
    local function TogglehiddenButtonsGrid()
        if InCombatLockdown() then return end;

        local shouldShow = bit.bor((tonumber(SpellBookFrame:IsShown() and 1) or GetCVar("alwaysShowActionBars")));
        for _, button in next, hiddenButtons do
            button:SetAttribute("showgrid", shouldShow);
            ActionButton_ShowGrid(button, ACTION_BUTTON_SHOW_GRID_REASON_EVENT);
        end;
    end;

    hooksecurefunc("MultiActionBar_UpdateGridVisibility", TogglehiddenButtonsGrid);
    SpellBookFrame:HookScript("OnShow", TogglehiddenButtonsGrid);
    SpellBookFrame:HookScript("OnHide", TogglehiddenButtonsGrid);
end;

-- Position the main action bars and buttons
local function SetupActionbars()
    if InCombatLockdown() then return end;

    local currentY = edgeOffset - 1;

    -- Tracking bars
    StatusTrackingBarManager:ClearAllPoints();
    StatusTrackingBarManager:SetPoint("BOTTOMLEFT", actionbarFrame, "BOTTOMLEFT", -2, currentY);
    currentY = currentY + btnSpacing + StatusTrackingBarManager:GetHeight() - 2;

    -- Main bars
    ActionButton1:ClearAllPoints();
    ActionButton1:SetPoint("BOTTOMLEFT", actionbarFrame, "BOTTOMLEFT", 0, currentY);
    currentY = currentY + btnSpacing + btnSize;

    -- Bottomleft multibar
    if (SHOW_MULTI_ACTIONBAR_1) then
	    MultiBarBottomLeftButton1:ClearAllPoints();
        MultiBarBottomLeftButton1:SetPoint("BOTTOMLEFT", actionbarFrame, "BOTTOMLEFT", 0, currentY);
        currentY = currentY + btnSpacing + btnSize;
    end;

    -- Bottomright multibar
    if (SHOW_MULTI_ACTIONBAR_2) then
        MultiBarBottomRightButton1:ClearAllPoints();
        MultiBarBottomRightButton1:SetPoint("BOTTOMLEFT", actionbarFrame, "BOTTOMLEFT", 0, currentY);
        currentY = currentY + btnSpacing + btnSize;
    end

    -- Others
    ExtraActionButton1:ClearAllPoints();
	ExtraActionButton1:SetPoint("BOTTOM", actionbarFrame, 0, 200);
    MainMenuBarVehicleLeaveButton:ClearAllPoints();
    MainMenuBarVehicleLeaveButton:SetPoint("BOTTOMRIGHT", actionbarFrame, "BOTTOMRIGHT", 1, currentY);
    PetActionButton1:ClearAllPoints();
	PetActionButton1:SetPoint("BOTTOMLEFT", actionbarFrame, "BOTTOMLEFT", (barWidth - petBarWidth) / 2, currentY + 1);
	PossessButton1:ClearAllPoints();
    PossessButton1:SetPoint("BOTTOMLEFT", actionbarFrame, "BOTTOMLEFT", -1, currentY);
    StanceButton1:ClearAllPoints();
    StanceButton1:SetPoint("BOTTOMLEFT", actionbarFrame, "BOTTOMLEFT", -1, currentY);

    -- Right bars
    local offsetY = MTUI.db.global.actionbarRightOffsetY;
    MultiBarRightButton1:ClearAllPoints();
    MultiBarRightButton1:SetPoint("TOPRIGHT", UIParent, "RIGHT", -edgeOffset, barWidth / 2 + offsetY - 72);
    MultiBarLeftButton1:ClearAllPoints();
    MultiBarLeftButton1:SetPoint("TOPRIGHT", MultiBarRightButton1, "TOPLEFT", -btnSpacing, 0);

    -- Set button spacing
    for _, type in next, { "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton" } do
        for i = 2, 12 do
            _G[type..i]:ClearAllPoints();
            _G[type..i]:SetPoint("BOTTOMLEFT", _G[type..i-1], "BOTTOMRIGHT", btnSpacing, 0);
        end;
    end;

    for _, type in next, { "MultiBarRightButton", "MultiBarLeftButton" } do
        for i = 2, 12 do
            _G[type..i]:ClearAllPoints();
            _G[type..i]:SetPoint("TOPRIGHT", _G[type..i-1], "BOTTOMRIGHT", 0, -btnSpacing);
        end;
    end;

    for i = 2, NUM_STANCE_SLOTS do
        _G["StanceButton"..i]:ClearAllPoints();
        _G["StanceButton"..i]:SetPoint("BOTTOMLEFT", _G["StanceButton"..i-1], "BOTTOMLEFT", btnSizeSmall + btnSpacing - 2, 0);
    end;

    for i = 2, NUM_PET_ACTION_SLOTS do
        _G["PetActionButton"..i]:ClearAllPoints();
        _G["PetActionButton"..i]:SetPoint("BOTTOMLEFT", _G["PetActionButton"..i-1], "BOTTOMLEFT", btnSizeSmall + btnSpacing, 0);
    end;
end;

-- Set up xp/ap/rep bars
local function SetupTrackbars(frame, bar, barWidth, isTopBar, isDouble)
    if trackerHeight == 0 then
        return frame:Hide();
    end;

    local TRACK_WIDTH = barWidth + 3;
    frame:SetDoubleBarSize(bar, TRACK_WIDTH);
    frame:SetSize(TRACK_WIDTH, trackerHeight * frame:GetNumberVisibleBars());
    frame:Show();

    bar:ClearAllPoints();
    bar.StatusBar:ClearAllPoints();
    bar:SetSize(TRACK_WIDTH, trackerHeight);
    bar.StatusBar:SetSize(TRACK_WIDTH, trackerHeight);
    bar.StatusBar.Background:SetAlpha(0.5);

    if MTUI.db.global.smoothBarTexture then
        bar.StatusBar:SetStatusBarTexture(MTUI.db.global.barTexture);
    end;

    if isDouble and isTopBar then
        bar:SetPoint("TOP", frame, "TOP", 0, 0);
        bar.StatusBar:SetPoint("TOP", frame, "TOP", 0, 0);
    else
        bar:SetPoint("BOTTOM", frame, "BOTTOM", 0, 0);
        bar.StatusBar:SetPoint("BOTTOM", frame, "BOTTOM", 0, 0);
    end;

    for _, b in next, { frame.SingleBarSmallUpper, frame.SingleBarLargeUpper, frame.SingleBarSmall, frame.SingleBarLarge } do
        b:SetSize(TRACK_WIDTH, trackerHeight);
        b:SetVertexColor(0.9, 0.9, 0.9);
    end;

    for _, b in next, { frame.SingleBarSmallUpper, frame.SingleBarLargeUpper } do
        b:SetPoint("TOP", frame, "TOP", 0, 0);
    end;

    for _, b in next, { frame.SingleBarSmall, frame.SingleBarLarge } do
        if isDouble then
            b:SetPoint("BOTTOM", frame, "BOTTOM", 0, 0);
        else
            b:Hide();
        end;
    end;
end;

-- Move/hide/attach frames
local function SetupFrames()
    MicroButtonAndBagsBar:SetMovable(true);
    MicroButtonAndBagsBar:ClearAllPoints();
    MicroButtonAndBagsBar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -(edgeOffset - 6), edgeOffset - 3);
    MicroButtonAndBagsBar:SetUserPlaced(true);
    MicroButtonAndBagsBar:SetMovable(false);

    MainMenuBar:SetMovable(true);
    MainMenuBar:ClearAllPoints();
    MainMenuBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0);
    MainMenuBar:SetUserPlaced(true);
    MainMenuBar:SetMovable(false);

    for _, bar in next, {
        MainMenuBar,MultiBarLeft, MultiBarRight, StanceBar, PossessBar,
        PetActionBar, MicroButtonAndBagsBar, OverrideActionBar
    } do bar:SetParent(actionbarFrame) end;

    actionbarFrame:SetScale(MTUI.db.global.actionbarScale);
    actionbarFrame:SetPoint("BOTTOM", 0, 0);
    actionbarFrame:SetSize(barWidth, btnSize);
    actionbarFrame:Show();

    -- Disable mouse in order to make other addons work
    for _, bar in next, {
        MainMenuBar, MultiBarBottomLeft, MultiBarBottomRight, MultiBarLeft, MultiBarRight,
        PetActionBarFrame, PossessBarFrame, StanceBarFrame
    } do bar:EnableMouse(false) end;
end

function MTUI:InitializeBars(triggerListeners)
    LoadOptions();
    SetupFrames();
    HideArtwork();
    FixUntexturedButtons();

    hooksecurefunc("UIParent_ManageFramePositions", SetupActionbars);
    hooksecurefunc("OverrideActionBar_Leave", function() ShowPetActionBar(true) end);
    hooksecurefunc(StatusTrackingBarManager, "LayoutBar", SetupTrackbars);

    -- Fire listeners once to make sure we apply the layout
    SetupActionbars();
    StatusTrackingBarManager:UpdateBarsShown();
end;
