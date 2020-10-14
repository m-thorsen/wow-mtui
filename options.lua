local MTUI = LibStub("AceAddon-3.0"):GetAddon("MTUI");

function MTUI:GetOptions()
    return {
        name = "MTUI",
        handler = MTUI,
        type = "group",
        args = {
            aa = {
                order = 10,
                type = "header",
                name = "Enable/disable modules (triggers UI reload)",
            },
            ab = {
                order = 11,
                type = "toggle",
                name = "Enable actionbar tweaks",
                width = "full",
                get = function(info)
                    return self.db.global.enableActionbars;
                end,
                set = function(info, value)
                    self.db.global.enableActionbars = value;
                    ReloadUI()
                end,
            },
            ac = {
                order = 12,
                type = "toggle",
                name = "Move unit and quest log frames",
                width = "full",
                get = function(info)
                    return self.db.global.enableMoveFrames;
                end,
                set = function(info, value)
                    self.db.global.enableMoveFrames = value;
                    ReloadUI();
                end,
            },
            ad = {
                order = 13,
                type = "toggle",
                name = "Enable unitframe tweaks",
                width = "full",
                get = function(info)
                    return self.db.global.enableUnitframes;
                end,
                set = function(info, value)
                    self.db.global.enableUnitframes = value;
                    ReloadUI();
                end,
            },
            ae = {
                order = 14,
                type = "toggle",
                name = "Enable customized nameplates",
                width = "full",
                get = function(info)
                    return self.db.global.enableNameplates;
                end,
                set = function(info, value)
                    self.db.global.enableNameplates = value;
                    ReloadUI();
                end,
            },
            af = {
                order = 15,
                type = "toggle",
                name = "Enable custom status bar textures",
                width = "full",
                get = function(info)
                    return self.db.global.enableStatusbars;
                end,
                set = function(info, value)
                    self.db.global.enableStatusbars = value;
                    ReloadUI();
                end,
            },
            ag = {
                order = 16,
                type = "toggle",
                name = "Castingbar border",
                width = "full",
                get = function(info)
                    return self.db.global.enableCastingbarTweaks;
                end,
                set = function(info, value)
                    self.db.global.enableCastingbarTweaks = value;
                    ReloadUI();
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
                    return self.db.global.unitframeOffsetX;
                end,
                set = function(info, value)
                    self.db.global.unitframeOffsetX = value;
                    self:MoveFrames();
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
                    return self.db.global.unitframeOffsetY;
                end,
                set = function(info, value)
                    self.db.global.unitframeOffsetY = value;
                    self:MoveFrames();
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
                    return self.db.global.actionbarScale;
                end,
                set = function(info, value)
                    self.db.global.actionbarScale = value;
                    self:InitActionbars();
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
                    return self.db.global.actionbarRightOffsetY;
                end,
                set = function(info, value)
                    self.db.global.actionbarRightOffsetY = value;
                    self:InitActionbars();
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
                    return self.db.global.actionbarBtnSpacing;
                end,
                set = function(info, value)
                    self.db.global.actionbarBtnSpacing = value;
                    self:InitActionbars();
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
                    return self.db.global.actionbarTrackHeight;
                end,
                set = function(info, value)
                    self.db.global.actionbarTrackHeight = value;
                    self:InitActionbars();
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
                    self.db:ResetDB();
                    ReloadUI();
                end,
            }
        },
    };
end;
