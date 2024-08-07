local Cell
local clickCastingTable
local eventFrame = CreateFrame("Frame", "MT_CellFrame", UIParent);

eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if _G.Cell and not Cell then
        print(addonName)
        print(event)
                
        Cell = _G.Cell
        clickCastingTable = Cell.vars.clickCastings["useCommon"] and Cell.vars.clickCastings["common"] or Cell.vars.clickCastings[Cell.vars.playerSpecID]
    end
end);

local mouseKeyIDs = {
    ["Left"] = 1,
    ["Right"] = 2,
    ["Middle"] = 3,
    ["Button4"] = 4,
    ["Button5"] = 5,
}

local function DecodeKeyboard(fullKey)
    fullKey = string.gsub(fullKey, "alt", "alt-")
    fullKey = string.gsub(fullKey, "ctrl", "ctrl-")
    fullKey = string.gsub(fullKey, "shift", "shift-")
    local modifier, key = strmatch(fullKey, "^(.*-)(.+)$")
    if not modifier then -- no modifier
        modifier = ""
        key = fullKey
    end
    return modifier, key
end

local function GetBindingDisplay(modifier, key)
    modifier = modifier:gsub("%-", "|cff777777+|r")
    modifier = modifier:gsub("alt", "Alt")
    modifier = modifier:gsub("ctrl", "Ctrl")
    modifier = modifier:gsub("shift", "Shift")
    modifier = modifier:gsub("meta", "Command")

    if strfind(key, "^NUM") then
        key = _G["KEY_"..key]
    elseif strlen(key) ~= 1 then
        key = L[key]
    end

    return modifier..key
end

local function DecodeDB(t)
    local modifier, bindKey, bindType, bindAction

    if t[1] ~= "notBound" then
        local dash, key
        modifier, dash, key = strmatch(t[1], "^(.*)type(-*)(.+)$")

        if dash == "-" then
            if key == "SCROLLUP" then
                bindKey = "ScrollUp"
            elseif key == "SCROLLDOWN" then
                bindKey = "ScrollDown"
            else
                modifier, bindKey = DecodeKeyboard(key)
            end
        else -- normal mouse button
            bindKey = Cell.funcs:GetIndex(mouseKeyIDs, tonumber(key))
        end
    else
        modifier, bindKey = "", "notBound"
    end

    if not t[3] then
        bindType = "general"
        bindAction = t[2]
    else
        bindType = t[2]
        bindAction = t[3]
    end

    return modifier, bindKey, bindType, bindAction
end

local function GetBoundActionDisplay(bindType, bindAction)
    if bindAction == 'target' then
        return "[Target]"
    elseif bindAction == 'togglemenu' then
        return "[Menu]"
    elseif bindType == "spell" then
        local bindActionDisplay, icon
        bindAction, icon = Cell.funcs:GetSpellInfo(bindAction)
        if bindAction then
            return "|cFFFFFFFF"..bindAction.." |T"..icon..":0|t"
        else
            return "|cFFFF3030"..L["Invalid"]
        end
    end
end


local function ShowTips(tooltip)
    if clickCastingTable == nil or getn(clickCastingTable) == 0 then
        return
    end

    tooltip:AddLine(" ")

    for i, t in pairs(clickCastingTable) do
        local modifier, bindKey, bindType, bindAction = DecodeDB(t)
        local actionDisplay = GetBoundActionDisplay(bindType, bindAction)

        if actionDisplay then
            tooltip:AddDoubleLine(GetBindingDisplay(modifier, bindKey), actionDisplay)
        end
    end
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function (tooltip) 
    if strfind(tooltip:GetOwner():GetName(), "Cell") == nil or Cell == nil then 
        return
    end

    ShowTips(tooltip)
end)