local MTUI = LibStub("AceAddon-3.0"):GetAddon("MTUI")

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
                    return self.db.profile.enableBars
                end,
                set = function(info, value)
                    self.db.profile.enableBars = value
                    ReloadUI()
                end,
            },
            ac = {
                order = 12,
                type = "toggle",
                name = "Move unit and quest log frames",
                width = "full",
                get = function(info)
                    return self.db.profile.moveFrames
                end,
                set = function(info, value)
                    self.db.profile.moveFrames = value
                    ReloadUI()
                end,
            },
            ad = {
                order = 13,
                type = "toggle",
                name = "Unitframe tweaks",
                width = "full",
                get = function(info)
                    return self.db.profile.enableUnitframes
                end,
                set = function(info, value)
                    self.db.profile.enableUnitframes = value
                    ReloadUI()
                end,
            },
            ae = {
                order = 13,
                type = "toggle",
                name = "Nameplate tweaks",
                width = "full",
                get = function(info)
                    return self.db.profile.enableNames
                end,
                set = function(info, value)
                    self.db.profile.enableNames = value
                    ReloadUI()
                end,
            },
            ae = {
                order = 13,
                type = "toggle",
                name = "Smooth bar texture",
                width = "full",
                get = function(info)
                    return self.db.profile.enableTexture
                end,
                set = function(info, value)
                    self.db.profile.enableTexture = value
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
                name = "X spacing",
                min = 100,
                max = 500,
                step = 1,
                get = function(info)
                    return self.db.profile.unitframeOffsetX
                end,
                set = function(info, value)
                    self.db.profile.unitframeOffsetX = value
                    self:MoveFrames()
                end,
            },
            bc = {
                order = 22,
                type = "range",
                name = "Y offset",
                min = 150,
                max = 300,
                step = 1,
                get = function(info)
                    return self.db.profile.unitframeOffsetY
                end,
                set = function(info, value)
                    self.db.profile.unitframeOffsetY = value
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
                    return self.db.profile.actionbarScale
                end,
                set = function(info, value)
                    self.db.profile.actionbarScale = value
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
                    return self.db.profile.actionbarRightOffsetY
                end,
                set = function(info, value)
                    self.db.profile.actionbarRightOffsetY = value
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
                    return self.db.profile.actionbarBtnSpacing
                end,
                set = function(info, value)
                    self.db.profile.actionbarBtnSpacing = value
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
                    return self.db.profile.actionbarTrackHeight
                end,
                set = function(info, value)
                    self.db.profile.actionbarTrackHeight = value
                    self:InitializeBars()
                end,
            }
        },
    }
end
