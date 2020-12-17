local MTUI = LibStub("AceAddon-3.0"):NewAddon("MTUI", "AceConsole-3.0");

local defaults = {
    global = {
        enableCastingbar      = true,
        enableMoveFrames      = true,
        enableUnitframes      = true,
        enableNameplates      = true,
        enableActionbars      = true,
        enableStatusbars      = true,
        enableMinorStatusbars = true,
        unitframeOffsetY      = 200,
        unitframeOffsetX      = 250,
        actionbarScale        = 1,
        actionbarStacked      = true,
        actionbarRightOffsetY = 0,
        actionbarBtnSpacing   = 1,
        actionbarTrackHeight  = 10,
        statusbarTexture      = "Interface/Addons/MTUI/Media/Textures/default",
        nameplateTexture      = "Interface/Addons/MTUI/Media/Textures/raidbar",
        -- nameplateTexture      = "Interface/Addons/MTUI/Media/Textures/default",
    }
};

-- Called when the addon is loaded
function MTUI:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("MTUIDB", defaults, true);
    LibStub("AceConfig-3.0"):RegisterOptionsTable("MTUI", self:GetOptions());
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("MTUI", "MTUI");

    if (self.db.global.enableActionbars) then
        self:InitActionbars();
    end;

    if (self.db.global.enableNameplates) then
        self:InitNameplates();
    end;

    if (self.db.global.enableUnitframes) then
        self:InitUnitframes();
    end;

    if (self.db.global.enableMoveFrames) then
        self:InitMoveFrames();
    end;

    if (self.db.global.enableStatusbars) then
        self:InitStatusbars();
    end;

    if (self.db.global.enableCastingbar) then
        self:InitCastingbar()
    end;

    self:InitAnnoyances(); -- Not optional!
    self:RegisterChatCommand("mtui", "ChatCommand");
end;

function MTUI:OnEnable() end;
function MTUI:OnDisable() end;
function MTUI:ChatCommand()
    InterfaceOptionsFrame_OpenToCategory(self.optionsFrame);
    InterfaceOptionsFrame_OpenToCategory(self.optionsFrame); -- Intentionally called twice due to a bliz bug
end;
