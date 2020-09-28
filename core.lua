local MTUI = LibStub("AceAddon-3.0"):NewAddon("MTUI", "AceConsole-3.0");

local defaults = {
    global = {
        enableBars = true,
        moveFrames = true,
        enableUnitframes = true,
        enableNameplateTweaks = true,
        enableCastingbarTweaks = true,
        barTexture = "Interface/Addons/MTUI/Media/Textures/default-zoomed-darker",
        namePlateTexture = "Interface/Addons/MTUI/Media/Textures/flatter-zoomed-darker",
        smoothBarTexture = true,
        actionbarScale = 1,
        actionbarRightOffsetY = 0,
        actionbarBtnSpacing = 1,
        actionbarTrackHeight = 10,
        unitframeOffsetY = 200,
        unitframeOffsetX = 250,
    }
};

-- Called when the addon is loaded
function MTUI:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("MTUIDB", defaults, true);
    LibStub("AceConfig-3.0"):RegisterOptionsTable("MTUI", self:GetOptions());
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("MTUI", "MTUI");
    self:RegisterChatCommand("mtui", "ChatCommand");
    self:RemoveAnnoyances();
    if (self.db.global.moveFrames) then self:MoveFrames() end;
    if (self.db.global.enableBars) then self:InitializeBars() end;
    if (self.db.global.enableNameplateTweaks) then self:InitializePlates() end;
    if (self.db.global.enableUnitframes) then self:InitializeUnitframes() end;
    if (self.db.global.smoothBarTexture) then self:ApplyBarTexture() end;
    if (self.db.global.enableCastingbarTweaks) then self:ApplyCastingbarTweaks() end;
end;

function MTUI:OnEnable() end;
function MTUI:OnDisable() end;
function MTUI:ChatCommand()
    InterfaceOptionsFrame_OpenToCategory(self.optionsFrame);
    InterfaceOptionsFrame_OpenToCategory(self.optionsFrame); -- Intentionally called twice due to a bliz bug
end;

-- Return an appropriate unit color based on class (or threat situation)
function MTUI:GetUnitColor(unit, useThreatColors)
    if UnitIsTapDenied(unit) or not UnitIsConnected(unit) then
        return GRAY_FONT_COLOR:GetRGB();
    elseif UnitIsPlayer(unit) and UnitClass(unit) then
        local _, class = UnitClass(unit);
        local c = RAID_CLASS_COLORS[class];
        return c.r, c.g, c.b;
    elseif UnitReaction(unit, "player") and UnitReaction(unit, "player") > 4 then
        return GREEN_FONT_COLOR:GetRGB();
    elseif (useThreatColors) then
        threatLevel = UnitThreatSituation("player", unit);
        if threatLevel == 3 then
            return RED_FONT_COLOR:GetRGB();
        elseif threatLevel == 2 then
            return ORANGE_FONT_COLOR:GetRGB();
        elseif threatLevel == 1 then
            return YELLOW_FONT_COLOR:GetRGB();
        elseif threatLevel ~= nil then
            return GREEN_FONT_COLOR:GetRGB();
        end;
    else
        return UnitSelectionColor(unit, true);
    end;
end;

function MTUI:GetOptions()
    return {
        name = "MTUI",
        handler = MTUI,
        type = "group",
        args = {
            aa = {
                order = 10,
                type = "header",
                name = "Enable/disable (Reloads)",
            },
            ab = {
                order = 11,
                type = "toggle",
                name = "Actionbar tweaks",
                width = "full",
                get = function(info)
                    return self.db.global.enableBars
                end,
                set = function(info, value)
                    self.db.global.enableBars = value
                    ReloadUI()
                end,
            },
            ac = {
                order = 12,
                type = "toggle",
                name = "Move unit and quest log frames",
                width = "full",
                get = function(info)
                    return self.db.global.moveFrames
                end,
                set = function(info, value)
                    self.db.global.moveFrames = value
                    ReloadUI()
                end,
            },
            ad = {
                order = 13,
                type = "toggle",
                name = "Unitframe tweaks",
                width = "full",
                get = function(info)
                    return self.db.global.enableUnitframes
                end,
                set = function(info, value)
                    self.db.global.enableUnitframes = value
                    ReloadUI()
                end,
            },
            ae = {
                order = 14,
                type = "toggle",
                name = "Nameplate tweaks",
                width = "full",
                get = function(info)
                    return self.db.global.enableNameplateTweaks
                end,
                set = function(info, value)
                    self.db.global.enableNameplateTweaks = value
                    ReloadUI()
                end,
            },
            -- af = {
            --     order = 15,
            --     type = "toggle",
            --     name = "Smooth bar texture",
            --     width = "full",
            --     get = function(info)
            --         return self.db.global.smoothBarTexture
            --     end,
            --     set = function(info, value)
            --         self.db.global.smoothBarTexture = value
            --         ReloadUI()
            --     end,
            -- },
            ag = {
                order = 16,
                type = "toggle",
                name = "Castingbar border",
                width = "full",
                get = function(info)
                    return self.db.global.enableCastingbarTweaks
                end,
                set = function(info, value)
                    self.db.global.enableCastingbarTweaks = value
                    ReloadUI()
                end,
            },
            ba = {
                order = 20,
                type = "header",
                name = "Unitframes",
            },
            bb = {
                order = 21,
                type = "range",
                name = "Space between",
                min = 100,
                max = 500,
                step = 1,
                get = function(info)
                    return self.db.global.unitframeOffsetX
                end,
                set = function(info, value)
                    self.db.global.unitframeOffsetX = value
                    self:MoveFrames()
                end,
            },
            bc = {
                order = 22,
                type = "range",
                name = "Distance from bottom",
                min = 150,
                max = 300,
                step = 1,
                get = function(info)
                    return self.db.global.unitframeOffsetY
                end,
                set = function(info, value)
                    self.db.global.unitframeOffsetY = value
                    self:MoveFrames()
                end,
            },
            ca = {
                order = 30,
                type = "header",
                name = "Actionbars",
            },
            cb = {
                order = 31,
                type = "range",
                name = "Scale",
                min = 0.5,
                max = 1.5,
                step = 0.05,
                get = function(info)
                    return self.db.global.actionbarScale
                end,
                set = function(info, value)
                    self.db.global.actionbarScale = value
                    self:InitializeBars()
                end,
            },
            cc = {
                order = 32,
                type = "range",
                name = "Right bar vertical offset",
                min = -200,
                max = 200,
                step = 1,
                get = function(info)
                    return self.db.global.actionbarRightOffsetY
                end,
                set = function(info, value)
                    self.db.global.actionbarRightOffsetY = value
                    self:InitializeBars()
                end,
            },
            cd = {
                order = 33,
                type = "range",
                name = "Button spacing",
                min = 0,
                max = 10,
                step = 1,
                get = function(info)
                    return self.db.global.actionbarBtnSpacing
                end,
                set = function(info, value)
                    self.db.global.actionbarBtnSpacing = value
                    self:InitializeBars()
                end,
            },
            ce = {
                order = 34,
                type = "range",
                name = "XP bar height",
                min = 0,
                max = 20,
                step = 1,
                get = function(info)
                    return self.db.global.actionbarTrackHeight
                end,
                set = function(info, value)
                    self.db.global.actionbarTrackHeight = value
                    self:InitializeBars()
                end,
            },
            da = {
                order = 40,
                type = "header",
                name = "Misc",
            },
            db = {
                order = 41,
                type = "execute",
                name = "Reset to defaults",
                func = function()
                    self.db:ResetDB()
                    ReloadUI()
                end,
            }
        },
    };
end;
