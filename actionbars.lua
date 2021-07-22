local MTUIActionbarFrame = CreateFrame("Frame", "MTUIActionbarFrame", UIParent);
local opts = {};

-- Update options
local function LoadOptions()
    if (InCombatLockdown()) then return end;

    opts.btnSize            = 36;
    opts.btnSizeSmall       = 30; -- pet, stance etc
    opts.btnSpacing         = MTUI.actionbars.spacing + 4;
    opts.actionbarWidth     = (opts.btnSize + opts.btnSpacing) * NUM_MULTIBAR_BUTTONS - opts.btnSpacing;
    opts.trackingbarHeight  = MTUI.actionbars.trackHeight;
    opts.trackingbarWidth   = opts.actionbarWidth + 3;
    opts.petbarWidth        = (opts.btnSizeSmall + opts.btnSpacing) * NUM_PET_ACTION_SLOTS - (opts.btnSpacing * 0.75);
    opts.edgeOffset         = opts.btnSpacing - 3;
    opts.stacked            = MTUI.actionbars.stacked;
    opts.hideMicro          = MTUI.actionbars.hideMicro;
    opts.hideStance         = MTUI.actionbars.hideStance;
end;

-- Some action buttons don't have a grid bg, as they are normally in front of the main menu artwork
-- Add this, and show/hide the grid when appropriate (such as when viewing the spellbook)
local function SkinUnskinnedBtns()
    local btns = {};

    for i = 1, 12 do tinsert(btns, _G["ActionButton"..i]) end;
    for i = 1, 6 do tinsert(btns, _G["MultiBarBottomRightButton"..i]) end;
    for _, btn in next, btns do
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

    local function ShowUnskinnedButtonsGrid()
        if (InCombatLockdown()) then return end;

        local shouldShow = bit.bor((tonumber(SpellBookFrame:IsShown() and 1) or GetCVar("alwaysShowActionBars")));
        for _, btn in next, btns do
            btn:SetAttribute("showgrid", shouldShow);
            btn:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_EVENT);
        end;
    end;

    hooksecurefunc("MultiActionBar_UpdateGridVisibility", ShowUnskinnedButtonsGrid);
    hooksecurefunc("SpellButton_OnShow", ShowUnskinnedButtonsGrid);
    hooksecurefunc("SpellButton_OnHide", ShowUnskinnedButtonsGrid);
end;

-- Hide some frames/textures
local function HideFrames()
    for _, f in next, {
        ActionBarUpButton, ActionBarDownButton, OverrideActionBarEndCapL, OverrideActionBarEndCapR,
        MainMenuBarArtFrame.PageNumber, MainMenuBarArtFrame.LeftEndCap, MainMenuBarArtFrame.RightEndCap,
        MainMenuBarArtFrameBackground, MainMenuBarBackpackButton, MainMenuBarPerformanceBar,
        MicroButtonAndBagsBar.MicroBagBar,
    } do f:Hide() end;
    for i = 0, 3 do _G["CharacterBag"..i.."Slot"]:Hide() end;
    for i = 1, 2 do _G["PossessBackground"..i]:SetTexture(nil) end;
    for i = 0, 1 do _G["SlidingActionBarTexture"..i]:SetTexture(nil) end;
    for _, tex in next, { StanceBarLeft, StanceBarMiddle, StanceBarRight } do tex:SetTexture(nil) end;

    -- Move some frames
    MicroButtonAndBagsBar:SetMovable(true);
    MicroButtonAndBagsBar:ClearAllPoints();
    MicroButtonAndBagsBar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -(opts.edgeOffset - 6), opts.edgeOffset - 5);
    MicroButtonAndBagsBar:SetUserPlaced(true);
    MicroButtonAndBagsBar:SetMovable(false);

    -- Attach some frames to our frame so they can be scaled together
    for _, bar in next, {
        MainMenuBar, MultiBarLeft, MultiBarRight, StanceBarFrame, PossessBarFrame,
        PetMTUIActionbarFrame, MicroButtonAndBagsBar, OverrideActionBar
    } do
        bar:SetParent(MTUIActionbarFrame);
    end;

    -- Set our frame's scale and position
    MTUIActionbarFrame:SetScale(MTUI.actionbars.scale);
    MTUIActionbarFrame:SetPoint("BOTTOM", 0, 0);
    MTUIActionbarFrame:SetSize(opts.actionbarWidth, opts.btnSize);
    MTUIActionbarFrame:Show();

    -- Disable some mouse events to avoid conflicts
    for _, bar in next, {
        MainMenuBar, MultiBarLeft, MultiBarRight, StanceBarFrame, PossessBarFrame,
        PetMTUIActionbarFrame, MultiBarBottomLeft, MultiBarBottomRight,
    } do
        bar:EnableMouse(false);
    end;

    if (opts.hideMicro) then
        MicroButtonAndBagsBar:SetAlpha(0);
        MicroButtonAndBagsBar:SetScale(0.0001);
    else
        MicroButtonAndBagsBar:SetAlpha(1);
        MicroButtonAndBagsBar:SetScale(1);
    end;

    if (opts.hideStance) then
        StanceBarFrame:SetAlpha(0);
    else
        StanceBarFrame:SetAlpha(1);
    end;
end;

-- Position the main action bars and buttons
local function LayoutActionbars()
    if (InCombatLockdown()) then return end;

    local currentY = opts.edgeOffset;

    -- Tracking bars
    if (StatusTrackingBarManager:GetNumberVisibleBars() > 0) then
        StatusTrackingBarManager:ClearAllPoints();
        StatusTrackingBarManager:SetPoint("BOTTOMLEFT", MTUIActionbarFrame, "BOTTOMLEFT", -2, currentY);
        currentY = currentY + opts.btnSpacing - 2 + StatusTrackingBarManager:GetHeight();
    end;

    -- Main bars
    ActionButton1:ClearAllPoints();
    ActionButton1:SetPoint("BOTTOMLEFT", MTUIActionbarFrame, "BOTTOMLEFT", 0, currentY);
    currentY = currentY + opts.btnSpacing + opts.btnSize;

    -- Bottomleft multibar
    if (SHOW_MULTI_ACTIONBAR_1) then
	    MultiBarBottomLeftButton1:ClearAllPoints();
        MultiBarBottomLeftButton1:SetPoint("BOTTOMLEFT", MTUIActionbarFrame, "BOTTOMLEFT", 0, currentY);
        currentY = currentY + opts.btnSpacing + opts.btnSize;
    else
        -- Fix a visual glitch when bottomleft is hidden
        for i = 1, NUM_STANCE_SLOTS do
            _G["StanceButton"..i.."NormalTexture2"]:SetSize(opts.btnSizeSmall + 22, opts.btnSizeSmall + 22);
        end;
    end;

    -- Bottomright multibar
    if (SHOW_MULTI_ACTIONBAR_2) then
        if (opts.stacked) then
            MultiBarBottomRightButton1:SetPoint("BOTTOMLEFT", MTUIActionbarFrame, "BOTTOMLEFT", 0, currentY);
            currentY = currentY + opts.btnSpacing + opts.btnSize;
        else
            MTUIActionbarFrame:SetWidth(opts.actionbarWidth * 1.5);
            opts.trackingbarWidth = (opts.actionbarWidth * 1.5) + 3 + (opts.btnSpacing / 2);
            MultiBarBottomRightButton1:ClearAllPoints();
            MultiBarBottomRightButton1:SetPoint("BOTTOMLEFT", ActionButton12, "BOTTOMRIGHT", opts.btnSpacing, 0);
            MultiBarBottomRightButton7:ClearAllPoints();
            MultiBarBottomRightButton7:SetPoint("BOTTOMLEFT", ActionButton12, "TOPRIGHT", opts.btnSpacing, opts.btnSpacing);
        end;
        for i = 2, 12 do
            -- If we're not stacking bottomright, don't reposition button #7 (first on second row)
            if (opts.stacked or i ~= 7) then
                _G["MultiBarBottomRightButton"..i]:ClearAllPoints();
                _G["MultiBarBottomRightButton"..i]:SetPoint("BOTTOMLEFT", _G["MultiBarBottomRightButton"..i-1], "BOTTOMRIGHT", opts.btnSpacing, 0);
            end;
        end;
    else
        MTUIActionbarFrame:SetWidth(opts.actionbarWidth);
        opts.trackingbarWidth = opts.actionbarWidth + 3;
    end

    -- Right bars
    local offsetY = MTUI.actionbars.rightOffsetY;
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

    StanceButton1:ClearAllPoints();
    StanceButton1:SetPoint("BOTTOMLEFT", MTUIActionbarFrame, "BOTTOMLEFT", -1, currentY + 0.5);
    for i = 2, NUM_STANCE_SLOTS do
        _G["StanceButton"..i]:ClearAllPoints();
        _G["StanceButton"..i]:SetPoint("BOTTOMLEFT", _G["StanceButton"..i-1], "BOTTOMLEFT", opts.btnSizeSmall + opts.btnSpacing - 2, 0);
    end;

    PetActionButton1:ClearAllPoints();
	PetActionButton1:SetPoint("BOTTOMLEFT", MTUIActionbarFrame, "BOTTOMLEFT", (opts.actionbarWidth - opts.petbarWidth) / 2, currentY + 1.5);
    for i = 2, NUM_PET_ACTION_SLOTS do
        _G["PetActionButton"..i]:ClearAllPoints();
        _G["PetActionButton"..i]:SetPoint("BOTTOMLEFT", _G["PetActionButton"..i-1], "BOTTOMLEFT", opts.btnSizeSmall + opts.btnSpacing, 0);
    end;

    -- Others
    -- ExtraActionButton1:ClearAllPoints();
	-- ExtraActionButton1:SetPoint("BOTTOM", MTUIActionbarFrame, 0, 200);
    MainMenuBarVehicleLeaveButton:ClearAllPoints();
    MainMenuBarVehicleLeaveButton:SetPoint("BOTTOMRIGHT", MTUIActionbarFrame, "BOTTOMRIGHT", 1, currentY);
	PossessButton1:ClearAllPoints();
    PossessButton1:SetPoint("BOTTOMLEFT", MTUIActionbarFrame, "BOTTOMLEFT", -1, currentY);
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

    if (isDouble and isTopBar) then
        bar:SetPoint("TOP", frame, "TOP", 0, 0);
        bar.StatusBar:SetPoint("TOP", frame, "TOP", 0, 0);
    else
        bar:SetPoint("BOTTOM", frame, "BOTTOM", 0, 0);
        bar.StatusBar:SetPoint("BOTTOM", frame, "BOTTOM", 0, 0);
    end;

    for _, b in next, { frame.SingleBarSmallUpper, frame.SingleBarLargeUpper, frame.SingleBarSmall, frame.SingleBarLarge } do
        b:SetSize(opts.trackingbarWidth, opts.trackingbarHeight);
        b:SetVertexColor(0.6, 0.6, 0.6);
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

function MTUI:InitActionbars()
    LoadOptions();
    HideFrames();
    SkinUnskinnedBtns();

    hooksecurefunc("UIParent_ManageFramePositions", LayoutActionbars);
    hooksecurefunc("OverrideActionBar_Leave", function() ShowPetActionBar(true) end);
    hooksecurefunc(StatusTrackingBarManager, "LayoutBar", LayoutTrackingbars);

    -- Fire some events once to make sure we apply the layout
    LayoutActionbars();
    StatusTrackingBarManager:UpdateBarsShown();
end;
