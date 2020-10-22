local MTUI = LibStub("AceAddon-3.0"):GetAddon("MTUI");
local actionbarFrame = CreateFrame("Frame", nil, UIParent);
local opts = {};

-- Update options
local function Setup()
    if (InCombatLockdown()) then return end;

    opts.btnSize           = 36;
    opts.btnSizeSmall      = 30; -- pet, stance etc
    opts.btnSpacing        = MTUI.db.global.actionbarBtnSpacing + 4;
    opts.actionbarWidth    = (opts.btnSize + opts.btnSpacing) * NUM_MULTIBAR_BUTTONS - opts.btnSpacing;
    opts.trackingbarHeight = MTUI.db.global.actionbarTrackHeight;
    opts.trackingbarWidth  = opts.actionbarWidth + 3;
    opts.petbarWidth       = (opts.btnSizeSmall + opts.btnSpacing) * NUM_PET_ACTION_SLOTS - opts.btnSpacing;
    opts.edgeOffset        = opts.btnSpacing - 3;
    opts.actionbarStacked  = MTUI.db.global.actionbarStacked;

    -- Some action buttons are untextured as they are normally in front of the main menu artwork
    opts.unstyledBtns      = {};

    for i = 1, 12 do
        tinsert(opts.unstyledBtns, _G["ActionButton"..i]);
    end;

    for i = 1, 6 do
        tinsert(opts.unstyledBtns, _G["MultiBarBottomRightButton"..i]);
    end;

    for _, btn in next, opts.unstyledBtns do
        btn.noGrid = nil;
        btn:Show();
        btn.NormalTexture:SetAlpha(0.5);
        if (not btn.floatingBG and not _G[btn:GetName().."FloatingBG"]) then
            btn.floatingBG = btn:CreateTexture();
            btn.floatingBG:SetPoint("TOPLEFT", btn, -15, 15);
            btn.floatingBG:SetPoint("BOTTOMRIGHT", btn, 15, -15);
            btn.floatingBG:SetTexture("Interface/Buttons/UI-Quickslot");
            btn.floatingBG:SetAlpha(0.4);
            btn.floatingBG:SetDrawLayer("BACKGROUND", -1);
        end;
    end;

    -- Hide some frames/textures
    for _, f in next, {
        ActionBarUpButton, ActionBarDownButton, OverrideActionBarEndCapL, OverrideActionBarEndCapR,
        MainMenuBarArtFrame.PageNumber, MainMenuBarArtFrame.LeftEndCap, MainMenuBarArtFrame.RightEndCap,
        MainMenuBarArtFrameBackground, MainMenuBarBackpackButton, MainMenuBarPerformanceBar,
        MicroButtonAndBagsBar.MicroBagBar,
    } do f:Hide() end;

    for i = 0, 3 do
        _G["CharacterBag"..i.."Slot"]:Hide();
    end;

    for i = 1, 2 do
        _G["PossessBackground"..i]:SetTexture(nil);
    end;

    for i = 0, 1 do
        _G["SlidingActionBarTexture"..i]:SetTexture(nil);
    end;

    for _, tex in next, { StanceBarLeft, StanceBarMiddle, StanceBarRight } do
        tex:SetTexture(nil);
    end;

    -- Move some frames
    MicroButtonAndBagsBar:SetMovable(true);
    MicroButtonAndBagsBar:ClearAllPoints();
    MicroButtonAndBagsBar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -(opts.edgeOffset - 6), opts.edgeOffset - 3);
    MicroButtonAndBagsBar:SetUserPlaced(true);
    MicroButtonAndBagsBar:SetMovable(false);
    MainMenuBar:SetMovable(true);
    MainMenuBar:ClearAllPoints();
    MainMenuBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0);
    MainMenuBar:SetUserPlaced(true);
    MainMenuBar:SetMovable(false);

    -- Attach some frames to our frame so they can be scaled together
    for _, bar in next, {
        MainMenuBar, MultiBarLeft, MultiBarRight, StanceBar, PossessBar,
        PetActionBar, MicroButtonAndBagsBar, OverrideActionBar
    } do
        bar:SetParent(actionbarFrame);
    end;

    -- Set our frame's scale and position
    actionbarFrame:SetScale(MTUI.db.global.actionbarScale);
    actionbarFrame:SetPoint("BOTTOM", 0, 0);
    actionbarFrame:SetSize(opts.actionbarWidth, opts.btnSize);
    actionbarFrame:Show();

    -- Disable some mouse events to avoid conflicts
    for _, bar in next, {
        MainMenuBar, PetActionBarFrame, PossessBarFrame, StanceBarFrame,
        MultiBarBottomLeft, MultiBarBottomRight, MultiBarLeft, MultiBarRight
    } do
        bar:EnableMouse(false);
    end;
end;

-- Show/hide unstyled buttons' grid when appropriate
local function ToggleUnstyledButtonsGrid()
    if (InCombatLockdown()) then return end;

    local shouldShow = bit.bor((tonumber(SpellBookFrame:IsShown() and 1) or GetCVar("alwaysShowActionBars")));
    for _, btn in next, opts.unstyledBtns do
        btn:SetAttribute("showgrid", shouldShow);
        btn:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_EVENT);
    end;
end;

-- Position the main action bars and buttons
local function LayoutActionbars()
    if (InCombatLockdown()) then return end;

    local currentY = opts.edgeOffset;

    -- Tracking bars
    if (StatusTrackingBarManager:GetNumberVisibleBars() > 0) then
        StatusTrackingBarManager:ClearAllPoints();
        StatusTrackingBarManager:SetPoint("BOTTOMLEFT", actionbarFrame, "BOTTOMLEFT", -2, currentY);
        currentY = currentY + opts.btnSpacing - 2 + StatusTrackingBarManager:GetHeight();
    end;

    -- Main bars
    ActionButton1:ClearAllPoints();
    ActionButton1:SetPoint("BOTTOMLEFT", actionbarFrame, "BOTTOMLEFT", 0, currentY);
    currentY = currentY + opts.btnSpacing + opts.btnSize;

    -- Bottomleft multibar
    if (SHOW_MULTI_ACTIONBAR_1) then
	    MultiBarBottomLeftButton1:ClearAllPoints();
        MultiBarBottomLeftButton1:SetPoint("BOTTOMLEFT", actionbarFrame, "BOTTOMLEFT", 0, currentY);
        currentY = currentY + opts.btnSpacing + opts.btnSize;
    else
        -- Fix a visual glitch when bottomleft is hidden
        for i = 1, NUM_STANCE_SLOTS do
            _G["StanceButton"..i.."NormalTexture2"]:SetSize(opts.btnSizeSmall + 22, opts.btnSizeSmall + 22);
        end;
    end;

    -- Bottomright multibar
    if (SHOW_MULTI_ACTIONBAR_2) then
        if (opts.actionbarStacked) then
            MultiBarBottomRightButton1:SetPoint("BOTTOMLEFT", actionbarFrame, "BOTTOMLEFT", 0, currentY);
            currentY = currentY + opts.btnSpacing + opts.btnSize;
        else
            actionbarFrame:SetWidth(opts.actionbarWidth * 1.5);
            opts.trackingbarWidth = (opts.actionbarWidth * 1.5) + 4 + (opts.btnSpacing / 2);
            MultiBarBottomRightButton1:ClearAllPoints();
            MultiBarBottomRightButton1:SetPoint("BOTTOMLEFT", ActionButton12, "BOTTOMRIGHT", opts.btnSpacing, 0);
            MultiBarBottomRightButton7:ClearAllPoints();
            MultiBarBottomRightButton7:SetPoint("BOTTOMLEFT", ActionButton12, "TOPRIGHT", opts.btnSpacing, opts.btnSpacing);
        end;
        for i = 2, 12 do
            -- If we're not stacking bottomright, don't reposition button #7 (first on second row)
            if (opts.actionbarStacked or i ~= 7) then
                _G["MultiBarBottomRightButton"..i]:ClearAllPoints();
                _G["MultiBarBottomRightButton"..i]:SetPoint("BOTTOMLEFT", _G["MultiBarBottomRightButton"..i-1], "BOTTOMRIGHT", opts.btnSpacing, 0);
            end;
        end;
    else
        actionbarFrame:SetWidth(opts.actionbarWidth);
        opts.trackingbarWidth = opts.actionbarWidth + 4;
    end

    -- Others
    ExtraActionButton1:ClearAllPoints();
	ExtraActionButton1:SetPoint("BOTTOM", actionbarFrame, 0, 200);
    MainMenuBarVehicleLeaveButton:ClearAllPoints();
    MainMenuBarVehicleLeaveButton:SetPoint("BOTTOMRIGHT", actionbarFrame, "BOTTOMRIGHT", 1, currentY);
    PetActionButton1:ClearAllPoints();
	PetActionButton1:SetPoint("BOTTOMLEFT", actionbarFrame, "BOTTOMLEFT", (opts.actionbarWidth - opts.petbarWidth) / 2, currentY + 1);
	PossessButton1:ClearAllPoints();
    PossessButton1:SetPoint("BOTTOMLEFT", actionbarFrame, "BOTTOMLEFT", -1, currentY);
    StanceButton1:ClearAllPoints();
    StanceButton1:SetPoint("BOTTOMLEFT", actionbarFrame, "BOTTOMLEFT", -1, currentY);

    -- Right bars
    local offsetY = MTUI.db.global.actionbarRightOffsetY;
    MultiBarRightButton1:ClearAllPoints();
    MultiBarRightButton1:SetPoint("TOPRIGHT", UIParent, "RIGHT", -opts.edgeOffset, opts.actionbarWidth / 2 + offsetY - 72);
    MultiBarLeftButton1:ClearAllPoints();
    MultiBarLeftButton1:SetPoint("TOPRIGHT", MultiBarRightButton1, "TOPLEFT", -opts.btnSpacing, 0);

    -- Set button spacing
    for _, type in next, { "ActionButton", "MultiBarBottomLeftButton" } do
        for i = 2, 12 do
            _G[type..i]:ClearAllPoints();
            _G[type..i]:SetPoint("BOTTOMLEFT", _G[type..i-1], "BOTTOMRIGHT", opts.btnSpacing, 0);
        end;
    end;

    for _, type in next, { "MultiBarRightButton", "MultiBarLeftButton" } do
        for i = 2, 12 do
            _G[type..i]:ClearAllPoints();
            _G[type..i]:SetPoint("TOPRIGHT", _G[type..i-1], "BOTTOMRIGHT", 0, -opts.btnSpacing);
        end;
    end;

    for i = 2, NUM_STANCE_SLOTS do
        _G["StanceButton"..i]:ClearAllPoints();
        _G["StanceButton"..i]:SetPoint("BOTTOMLEFT", _G["StanceButton"..i-1], "BOTTOMLEFT", opts.btnSizeSmall + opts.btnSpacing - 2, 0);
    end;

    for i = 2, NUM_PET_ACTION_SLOTS do
        _G["PetActionButton"..i]:ClearAllPoints();
        _G["PetActionButton"..i]:SetPoint("BOTTOMLEFT", _G["PetActionButton"..i-1], "BOTTOMLEFT", opts.btnSizeSmall + opts.btnSpacing, 0);
    end;
end;

-- Set up xp/ap/rep bars
local function LayoutTrackingbars(frame, bar, width, isTopBar, isDouble)
    if (opts.trackingbarHeight == 0) then
        return frame:Hide();
    end;

    frame:SetDoubleBarSize(bar, opts.trackingbarWidth);
    frame:SetSize(opts.trackingbarWidth, opts.trackingbarHeight * frame:GetNumberVisibleBars());
    frame:Show();

    bar:ClearAllPoints();
    bar:SetSize(opts.trackingbarWidth, opts.trackingbarHeight);
    bar.StatusBar:ClearAllPoints();
    bar.StatusBar:SetSize(opts.trackingbarWidth, opts.trackingbarHeight);

    if (MTUI.db.global.enableStatusbars) then
        bar.StatusBar:SetStatusBarTexture(MTUI.db.global.statusbarTexture);
    end;

    if (isDouble and isTopBar) then
        bar:SetPoint("TOP", frame, "TOP", 0, 0);
        bar.StatusBar:SetPoint("TOP", frame, "TOP", 0, 0);
    else
        bar:SetPoint("BOTTOM", frame, "BOTTOM", 0, 0);
        bar.StatusBar:SetPoint("BOTTOM", frame, "BOTTOM", 0, 0);
    end;

    for _, b in next, { frame.SingleBarSmallUpper, frame.SingleBarLargeUpper, frame.SingleBarSmall, frame.SingleBarLarge } do
        b:SetSize(opts.trackingbarWidth, opts.trackingbarHeight);
        b:SetVertexColor(0.9, 0.9, 0.9);
    end;

    for _, b in next, { frame.SingleBarSmallUpper, frame.SingleBarLargeUpper } do
        b:SetPoint("TOP", frame, "TOP", 0, 0);
    end;

    for _, b in next, { frame.SingleBarSmall, frame.SingleBarLarge } do
        if (isDouble) then
            b:SetPoint("BOTTOM", frame, "BOTTOM", 0, 0);
        else
            b:Hide();
        end;
    end;
end;

function MTUI:InitActionbars(triggerListeners)
    Setup();

    hooksecurefunc("UIParent_ManageFramePositions", LayoutActionbars);
    hooksecurefunc("OverrideActionBar_Leave", function() ShowPetActionBar(true) end);
    hooksecurefunc(StatusTrackingBarManager, "LayoutBar", LayoutTrackingbars);
    hooksecurefunc("MultiActionBar_UpdateGridVisibility", ToggleUnstyledButtonsGrid);
    SpellBookFrame:HookScript("OnShow", ToggleUnstyledButtonsGrid);
    SpellBookFrame:HookScript("OnHide", ToggleUnstyledButtonsGrid);

    -- Fire some events once to make sure we apply the layout
    LayoutActionbars();
    StatusTrackingBarManager:UpdateBarsShown();
end;
