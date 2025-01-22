

local pcoords = nil
local pdead = nil

local PlayerJob = nil

--[[ ------------------------------------------------
   Local Functions
]]---------------------------------------------------

-- @GetTableLength returns the length of a table.
local function GetTableLength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

local function HasRequiredJob(jobs)
    if ( not jobs ) or ( jobs and GetTableLength(jobs) < 0 ) then
        return true
    end

    for index, job in pairs (jobs) do

        if job == PlayerJob then
            return true
        end
    end

    return false

end

local function StartTeleportationProcess(coords)
    
    while not IsScreenFadedOut() do
        Wait(50)
        DoScreenFadeOut(2000)
    end

    Wait(2000)

    exports.tpz_core.rClientAPI().teleportToCoords( coords.x, coords.y, coords.z, coords.h)

    Wait(5000)
    DoScreenFadeIn(2000)
end

--[[ ------------------------------------------------
   Base Events 
]]---------------------------------------------------

-- @tpz_core:isPlayerReady : When a character is selected.
AddEventHandler("tpz_core:isPlayerReady", function()
    
    -- Keep in mind, the following data will be valid ONLY if the character has been selected.
    TriggerEvent("tpz_core:ExecuteServerCallBack", "tpz_core:getPlayerData", function(data)

        if data == nil then 
            return
        end

        PlayerJob = data.job
    end)

end)

if Config.DevMode then
    
    -- Keep in mind, the following data will be valid ONLY if the character has been selected.
    TriggerEvent("tpz_core:ExecuteServerCallBack", "tpz_core:getPlayerData", function(data)

        if data == nil then 
            return
        end

        PlayerJob = data.job
    end)

end

-- @param job
-- @param jobGrade
RegisterNetEvent("tpz_core:getPlayerJob")
AddEventHandler("tpz_core:getPlayerJob", function(data)
    PlayerJob = data.job
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
