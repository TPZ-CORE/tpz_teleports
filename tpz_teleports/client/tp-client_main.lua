

local pcoords = nil
local pdead = nil


--[[ ------------------------------------------------
   Functions
]]---------------------------------------------------



--[[ ------------------------------------------------
   Events
]]---------------------------------------------------

RegisterNetEvent('tpz_teleports:StartTeleportationProcess')
AddEventHandler('tpz_teleports:StartTeleportationProcess', function(coords)
    
    while not IsScreenFadedOut() do
        Wait(50)
        DoScreenFadeOut(2000)
    end

    Wait(2000)

    exports.tpz_core.rClientAPI().teleportToCoords( coords.x, coords.y, coords.z, coords.h)

    Wait(5000)
    DoScreenFadeIn(2000)
end)

--[[ ------------------------------------------------
   Threads
]]---------------------------------------------------

Citizen.CreateThread(function()

    RegisterActionPrompts()

    while true do

        Wait(0)

        local sleep = true

        if GetTableLength(Config.Locations) > 0 then

            local player       = PlayerPedId()
            local isEntityDead = IsEntityDead(player)

            local coords       = GetEntityCoords(player)
            local coordsDist   = vector3(coords.x, coords.y, coords.z)

            for _, locationConfig in pairs (Config.Locations) do

                local enterCoords   = vector3(locationConfig.EnterCoords.x, locationConfig.EnterCoords.y, locationConfig.EnterCoords.z)
                local exitCoords    = vector3(locationConfig.ExitCoords.x, locationConfig.ExitCoords.y, locationConfig.ExitCoords.z)

                if #(coordsDist - enterCoords) <= locationConfig.TeleportActionDistance then
                    sleep = false

                    local promptGroup, promptList = GetPromptData()

                    local label = CreateVarString(10, 'LITERAL_STRING', locationConfig.PromptFooterLabel)
                    PromptSetActiveGroupThisFrame(promptGroup, label)

                    PromptSetText(promptList, CreateVarString(10, 'LITERAL_STRING', Locales['ENTER']))

                    if PromptHasHoldModeCompleted(promptList) then
                        TriggerServerEvent('tpz_teleports:onEntrance', locationConfig.ExitCoords, _ )
                        Wait(3000)
                    end
    

                end

                if #(coordsDist - exitCoords) <= locationConfig.TeleportActionDistance then
                    sleep = false

                    local promptGroup, promptList = GetPromptData()

                    local label = CreateVarString(10, 'LITERAL_STRING', locationConfig.PromptFooterLabel)
                    PromptSetActiveGroupThisFrame(promptGroup, label)

                    PromptSetText(promptList, CreateVarString(10, 'LITERAL_STRING', Locales['LEAVE']))

                    if PromptHasHoldModeCompleted(promptList) then
                        TriggerEvent('tpz_teleports:StartTeleportationProcess', locationConfig.EnterCoords)
                        Wait(3000)
                    end
    

                end


            end

        end

    end


end)
