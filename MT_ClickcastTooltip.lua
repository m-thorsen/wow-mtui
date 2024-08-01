function GetActionName(binding)
    if binding.type == Enum.ClickBindingType.Interaction then
        if binding.actionID == Enum.ClickBindingInteraction.Target then
            return "[Target]"
        elseif binding.actionID == Enum.ClickBindingInteraction.OpenContextMenu then
            return "[Menu]"
        end
    elseif binding.type == Enum.ClickBindingType.Spell then
        return GetSpellInfo(binding.actionID)
    elseif binding.type == Enum.ClickBindingType.Macro then
        return GetMacroInfo(binding.actionID)
    end

    return tostring(binding.actionID)
end

function GetCurrentModifier()
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

function GetRelevantBindings()
    local filteredBindings = {}
    local clickBindings = C_ClickBindings.GetProfileInfo()

    for i, binding in ipairs(clickBindings) do
        if GetCurrentModifier() == C_ClickBindings.GetStringFromModifiers(binding.modifiers) then
            tinsert(filteredBindings, binding)
        end
    end

    return filteredBindings
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function (tooltip) 
    local ownerName = tooltip:GetOwner():GetName()

    if (strfind(ownerName, "Party") == nil and strfind(ownerName, "Player") == nil) then 
        return 
    end

    local bindings = GetRelevantBindings()

    if not bindings or getn(bindings) == 0 then
        return
    end

    tooltip:AddLine(" ")

    for i, binding in ipairs(bindings) do
        local btnName = gsub(binding.button, "Button", "")
        tooltip:AddDoubleLine(btnName, GetActionName(binding))
    end
end)