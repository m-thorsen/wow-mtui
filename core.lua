local MTUI = LibStub("AceAddon-3.0"):NewAddon("MTUI", "AceConsole-3.0")

local defaults = {
    profile = {
        enableBars = true,
        moveFrames = true,
        enableNames = true,
        enableUnitframes = true,
        barTexture = "Interface/Addons/mt_UI/Media/Smooth",
        enableTexture = true,
        actionbarScale = 0.9,
        actionbarRightOffsetY = 0,
        actionbarBtnSpacing = 2,
        actionbarTrackHeight = 10,
        unitframeOffsetY = 200,
        unitframeOffsetX = 250,
    }
}

-- Called when the addon is loaded
function MTUI:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("MTUIDB", defaults, true)

    LibStub("AceConfig-3.0"):RegisterOptionsTable("MTUI", self:GetOptions())
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("MTUI", "MTUI")
    self:RegisterChatCommand("mtui", "ChatCommand")

    if (self.db.profile.moveFrames) then self:MoveFrames() end
    if (self.db.profile.enableBars) then self:InitializeBars() end
    if (self.db.profile.enableNames) then self:InitializePlates() end
    if (self.db.profile.enableUnitframes) then self:InitializeUnitframes() end
    if (self.db.profile.enableTexture) then self:ApplyBarTexture() end
end

function MTUI:OnEnable() end
function MTUI:OnDisable() end
function MTUI:ChatCommand()
    InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
end

SetCVar("fullSizeFocusFrame", 0)
SetCVar("ShowClassColorInNamePlate", 1)
