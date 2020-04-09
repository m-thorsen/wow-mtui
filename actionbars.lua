local MTUI = LibStub("AceAddon-3.0"):GetAddon("MTUI")

-- Create a container frame
local AB_FRAME = CreateFrame("Frame", nil, UIParent)

-- Initialize vars
local BTN_SPACING, BTN_SIZE, BTN_SIZE_SM, BAR_WIDTH, PET_BAR_WIDTH, TRACK_HEIGHT, EDGE_OFFSET

-- Hide artwork
function MTUI:HideArtwork()
    if InCombatLockdown() then return end

    for _, f in next, {
        ActionBarUpButton, ActionBarDownButton, OverrideActionBarEndCapL, OverrideActionBarEndCapR,
        MainMenuBarArtFrame.PageNumber, MainMenuBarArtFrame.LeftEndCap, MainMenuBarArtFrame.RightEndCap,
        MainMenuBarArtFrameBackground, MainMenuBarBackpackButton, MainMenuBarPerformanceBar,
        MicroButtonAndBagsBar.MicroBagBar
    } do f:Hide() end

    for i = 0, 3 do _G["CharacterBag"..i.."Slot"]:Hide() end
    for i = 1, 2 do _G["PossessBackground"..i]:SetTexture(nil) end
    for i = 0, 1 do _G["SlidingActionBarTexture"..i]:SetTexture(nil) end
    for _, tex in next, { StanceBarLeft, StanceBarMiddle, StanceBarRight } do tex:SetTexture(nil) end
end

-- Some action buttons are untextured as they are normally in front of the main menu artwork
function MTUI:FixUntexturedButtons()
    local HiddenButtons = {}

    for i = 1, 12 do tinsert(HiddenButtons, _G["ActionButton"..i]) end
    for i = 1, 6 do tinsert(HiddenButtons, _G["MultiBarBottomRightButton"..i]) end

    for _, b in next, HiddenButtons do
        b.noGrid = nil
        b:Show()
        b.NormalTexture:SetAlpha(0.5)
        if not b.floatingBG and not _G[b:GetName().."FloatingBG"] then
            b.floatingBG = b:CreateTexture()
            b.floatingBG:SetPoint("TOPLEFT", b, -15, 15)
            b.floatingBG:SetPoint("BOTTOMRIGHT", b, 15, -15)
            b.floatingBG:SetTexture("Interface/Buttons/UI-Quickslot")
            b.floatingBG:SetAlpha(0.4)
            b.floatingBG:SetDrawLayer("BACKGROUND", -1)
        end
    end

    -- Show/hide these buttons' grid when appropriate
    local function ToggleHiddenButtonsGrid()
        if InCombatLockdown() then return end

        local shouldShow = bit.bor((tonumber(SpellBookFrame:IsShown() and 1) or GetCVar("alwaysShowActionBars")))
        for _, button in next, HiddenButtons do
            button:SetAttribute("showgrid", shouldShow)
            ActionButton_ShowGrid(button, ACTION_BUTTON_SHOW_GRID_REASON_EVENT)
        end
    end

    hooksecurefunc("MultiActionBar_UpdateGridVisibility", ToggleHiddenButtonsGrid)
    SpellBookFrame:HookScript("OnShow", ToggleHiddenButtonsGrid)
    SpellBookFrame:HookScript("OnHide", ToggleHiddenButtonsGrid)
end

local function StackBars()
    if InCombatLockdown() then return end

    local BAR_Y = EDGE_OFFSET

    -- Tracking bars
    StatusTrackingBarManager:SetPoint("BOTTOM", AB_FRAME, "BOTTOM", 0, BAR_Y + 1)
    BAR_Y = BAR_Y + BTN_SPACING + StatusTrackingBarManager:GetHeight() - 1

    -- Main bars
    ActionButton1:ClearAllPoints()
    ActionButton1:SetPoint("BOTTOMLEFT", AB_FRAME, "BOTTOMLEFT", 0, BAR_Y)
    BAR_Y = BAR_Y + BTN_SPACING + BTN_SIZE

    -- Bottomleft multibar
    if (SHOW_MULTI_ACTIONBAR_1) then
	    MultiBarBottomLeftButton1:ClearAllPoints()
        MultiBarBottomLeftButton1:SetPoint("BOTTOMLEFT", AB_FRAME, "BOTTOMLEFT", 0, BAR_Y)
        BAR_Y = BAR_Y + BTN_SPACING + BTN_SIZE
    end

    -- Bottomright multibar
    if (SHOW_MULTI_ACTIONBAR_2) then
        MultiBarBottomRightButton1:ClearAllPoints()
        MultiBarBottomRightButton1:SetPoint("BOTTOMLEFT", AB_FRAME, "BOTTOMLEFT", 0, BAR_Y)
        BAR_Y = BAR_Y + BTN_SPACING + BTN_SIZE
    end

    -- Others
    ExtraActionButton1:ClearAllPoints()
	ExtraActionButton1:SetPoint("BOTTOM", AB_FRAME, 0, 200)
    MainMenuBarVehicleLeaveButton:ClearAllPoints()
    MainMenuBarVehicleLeaveButton:SetPoint("BOTTOMRIGHT", AB_FRAME, "BOTTOMRIGHT", 1, BAR_Y)
    PetActionButton1:ClearAllPoints()
	PetActionButton1:SetPoint("BOTTOMLEFT", AB_FRAME, "BOTTOMLEFT", (BAR_WIDTH - PET_BAR_WIDTH) / 2, BAR_Y + 1)
	PossessButton1:ClearAllPoints()
    PossessButton1:SetPoint("BOTTOMLEFT", AB_FRAME, "BOTTOMLEFT", -1, BAR_Y)
    StanceButton1:ClearAllPoints()
    StanceButton1:SetPoint("BOTTOMLEFT", AB_FRAME, "BOTTOMLEFT", -1, BAR_Y)

    -- Right bars
    local offsetY = MTUI.db.profile.actionbarRightOffsetY
    MultiBarRightButton1:ClearAllPoints()
    MultiBarRightButton1:SetPoint("TOPRIGHT", UIParent, "RIGHT", -EDGE_OFFSET, BAR_WIDTH / 2 + offsetY - 72)
    MultiBarLeftButton1:ClearAllPoints()
    MultiBarLeftButton1:SetPoint("TOPRIGHT", MultiBarRightButton1, "TOPLEFT", -BTN_SPACING, 0)

    -- Set button spacing
    for _, type in next, { "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton" } do
        for i = 2, 12 do
            _G[type..i]:ClearAllPoints()
            _G[type..i]:SetPoint("BOTTOMLEFT", _G[type..i-1], "BOTTOMRIGHT", BTN_SPACING, 0)
        end
    end

    for _, type in next, { "MultiBarRightButton", "MultiBarLeftButton" } do
        for i = 2, 12 do
            _G[type..i]:ClearAllPoints()
            _G[type..i]:SetPoint("TOPRIGHT", _G[type..i-1], "BOTTOMRIGHT", 0, -BTN_SPACING)
        end
    end

    for i = 2, NUM_STANCE_SLOTS do
        _G["StanceButton"..i]:ClearAllPoints()
        _G["StanceButton"..i]:SetPoint("BOTTOMLEFT", _G["StanceButton"..i-1], "BOTTOMLEFT", BTN_SIZE_SM + BTN_SPACING - 2, 0)
    end

    for i = 2, NUM_PET_ACTION_SLOTS do
        _G["PetActionButton"..i]:ClearAllPoints()
        _G["PetActionButton"..i]:SetPoint("BOTTOMLEFT", _G["PetActionButton"..i-1], "BOTTOMLEFT", BTN_SIZE_SM + BTN_SPACING, 0)
    end
end

local function SetupTrackingBars(self, bar, barWidth, isTopBar, isDouble)
    self:SetDoubleBarSize(bar, BAR_WIDTH + 3)
    self:SetHeight(TRACK_HEIGHT * self:GetNumberVisibleBars())

    if TRACK_HEIGHT == 0 then
        return self:Hide()
    else
        self:Show()
    end

    bar:SetHeight(TRACK_HEIGHT)
    bar.StatusBar:SetHeight(TRACK_HEIGHT * 0.8)
    bar.StatusBar.Background:SetAlpha(0.5)

    if MTUI.db.profile.enableTexture then
        bar.StatusBar:SetStatusBarTexture(MTUI.db.profile.mediaPath..MTUI.db.profile.texture)
    end

    if isDouble and isTopBar then
        bar:SetPoint("BOTTOM", self, "BOTTOM", 0, TRACK_HEIGHT)
        bar.StatusBar:SetPoint("BOTTOM", self, "BOTTOM", 0, TRACK_HEIGHT)
    else
        bar:SetPoint("BOTTOM", self, "BOTTOM", 0, 0)
        bar.StatusBar:SetPoint("BOTTOM", self, "BOTTOM", 0, 0)
    end

    for _, b in next, { self.SingleBarSmallUpper, self.SingleBarLargeUpper, self.SingleBarSmall, self.SingleBarLarge } do
        b:SetHeight(TRACK_HEIGHT)
        b:SetVertexColor(0.75, 0.75, 0.75)
    end

    for _, b in next, { self.SingleBarSmallUpper, self.SingleBarLargeUpper } do
        b:SetPoint("TOP", self, "TOP", 0, 0)
    end

    for _, b in next, { self.SingleBarSmall, self.SingleBarLarge } do
        if isDouble then
            b:SetPoint("BOTTOM", self, "BOTTOM", 0, 0)
        else
            b:Hide()
        end
    end
end

function MTUI:SetupFrames()
    -- Move frames
    MicroButtonAndBagsBar:SetMovable(true)
    MicroButtonAndBagsBar:ClearAllPoints()
    MicroButtonAndBagsBar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -(EDGE_OFFSET - 6), EDGE_OFFSET - 3)
    MicroButtonAndBagsBar:SetUserPlaced(true)
    MicroButtonAndBagsBar:SetMovable(false)

    MainMenuBar:SetMovable(true)
    MainMenuBar:ClearAllPoints()
    MainMenuBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
    MainMenuBar:SetUserPlaced(true)
    MainMenuBar:SetMovable(false)

    -- Attach the bars we want to scale to the root frame
    for _, bar in next, {
        MainMenuBar,MultiBarLeft, MultiBarRight, StanceBar, PossessBar,
        PetActionBar, MicroButtonAndBagsBar, OverrideActionBar
    } do bar:SetParent(AB_FRAME) end

    AB_FRAME:SetScale(self.db.profile.actionbarScale)
    AB_FRAME:SetPoint("BOTTOM", 0, 0)
    AB_FRAME:SetSize(BAR_WIDTH, BTN_SIZE)
    AB_FRAME:Show()

    -- Disable mouse in order to make other addons work
    for _, bar in next, {
        MainMenuBar, MultiBarBottomLeft, MultiBarBottomRight, MultiBarLeft, MultiBarRight,
        PetActionBarFrame, PossessBarFrame, StanceBarFrame
    } do
        bar:EnableMouse(false)
    end
end

function MTUI:InitializeBars(triggerListeners)
    BTN_SIZE        = 36
    BTN_SIZE_SM     = 30 -- pet, stance etc
    TRACK_HEIGHT    = self.db.profile.actionbarTrackHeight
    BTN_SPACING     = self.db.profile.actionbarBtnSpacing + 4
    BAR_WIDTH       = (BTN_SIZE + BTN_SPACING) * NUM_MULTIBAR_BUTTONS - BTN_SPACING
    PET_BAR_WIDTH   = (BTN_SIZE_SM + BTN_SPACING) * NUM_PET_ACTION_SLOTS - BTN_SPACING
    EDGE_OFFSET     = BTN_SPACING - 3

    self:SetupFrames()
    self:HideArtwork()
    self:FixUntexturedButtons()

    hooksecurefunc("UIParent_ManageFramePositions", StackBars)
    hooksecurefunc("OverrideActionBar_Leave", function() ShowPetActionBar(true) end)
    hooksecurefunc(StatusTrackingBarManager, "LayoutBar", SetupTrackingBars)

    -- Fire listeners once to make sure we apply the layout
    StackBars()
    StatusTrackingBarManager:UpdateBarsShown()
end
