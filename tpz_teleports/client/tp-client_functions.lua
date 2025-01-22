local Prompts     = GetRandomIntInRange(0, 0xffffff)
local PromptsList = nil

--[[-------------------------------------------------------
 Prompts
]]---------------------------------------------------------

function RegisterActionPrompts()
    local keyPress =  Config.PromptKey

    local dPrompt = PromptRegisterBegin()
    PromptSetControlAction(dPrompt, keyPress)
    --str = CreateVarString(10, 'LITERAL_STRING', str)
    --PromptSetText(dPrompt, str)
    PromptSetEnabled(dPrompt, 1)
    PromptSetVisible(dPrompt, 1)
    PromptSetStandardMode(dPrompt, 1)
    PromptSetHoldMode(dPrompt, 1000)
    PromptSetGroup(dPrompt, Prompts)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, dPrompt, true)
    PromptRegisterEnd(dPrompt)

    PromptsList = dPrompt
end

GetPromptData = function ()
    return Prompts, PromptsList
end

--[[-------------------------------------------------------
 Events
]]---------------------------------------------------------

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    Citizen.InvokeNative(0x00EDE88D4D13CF59, Prompts) -- UiPromptDelete

    Prompts     = nil
    PromptsList = nil
end)
