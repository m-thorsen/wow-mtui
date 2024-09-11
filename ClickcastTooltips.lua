local _, MTUI = ...

local isInitalized = false

local function GetActionName(binding)
    local showBasics = MTUI.options.showMenuAndTargetActionInTooltips
    if showBasics and binding.type == Enum.ClickBindingType.Interaction then
        if binding.actionID == Enum.ClickBindingInteraction.Target then
            return "[Target]"
        elseif binding.actionID == Enum.ClickBindingInteraction.OpenContextMenu then
            return "[Menu]"
        end
    elseif binding.type == Enum.ClickBindingType.Spell then
        return C_Spell.GetSpellName(binding.actionID)
    elseif binding.type == Enum.ClickBindingType.Macro then
        return GetMacroInfo(binding.actionID)
    end
end

local function GetCurrentModifier()
    local modShift = IsShiftKeyDown()
    local modAlt = IsAltKeyDown()
    local modCtrl = IsControlKeyDown()
    if modShift and modAlt and modCtrl then 
        return "ALT-SHIFT-CTRL"
    elseif modShift and modAlt then 
        return "ALT-SHIFT"
    elseif modCtrl and modAlt then 
        return "SHIFT-CTRL"
    elseif modShift then 
        return "SHIFT"
    elseif modAlt then 
        return "ALT"
    elseif modCtrl then 
        return "CTRL"
    else 
        return ""
    end
end

local function GetRelevantBindings()
    local filteredBindings = {}
    local clickBindings = C_ClickBindings.GetProfileInfo()

    for i, binding in ipairs(clickBindings) do
        if GetCurrentModifier() == C_ClickBindings.GetStringFromModifiers(binding.modifiers) then
            tinsert(filteredBindings, binding)
        end
    end

    return filteredBindings
end

function MTUI.initClickcastTooltips()
    if isInitalized then return end

    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function (tooltip) 
        local ownerName = tooltip:GetOwner():GetName()

        if (strfind(ownerName, "Player") == nil and strfind(ownerName, "Party") == nil and strfind(ownerName, "Raid") == nil) then 
            return 
        end
    
        local bindings = GetRelevantBindings()
    
        if not bindings or getn(bindings) == 0 then
            return
        end
    
        tooltip:AddLine(" ")
    
        for _, binding in ipairs(bindings) do
            local btnName = gsub(binding.button, "Button", "")
            local actionName = GetActionName(binding)
            if actionName then
                tooltip:AddDoubleLine(btnName, actionName)
            end
        end
    end)

    isInitalized = true
end

