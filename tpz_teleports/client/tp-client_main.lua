
local TPZ = exports.tpz_core.getCoreAPI()
local PlayerJob = nil

--[[ ------------------------------------------------
   Local Functions
]]---------------------------------------------------

local function HasRequiredJob(jobs)
    if ( not jobs ) or ( jobs and TPZ.GetTableLength(jobs) < 0 ) then
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

    exports.tpz_core.getCoreAPI().TeleportToCoords( coords.x, coords.y, coords.z, coords.h)

    Wait(5000)
    DoScreenFadeIn(2000)
end

--[[ ------------------------------------------------
   Base Events 
]]---------------------------------------------------

-- @tpz_core:isPlayerReady : When a character is selected.
AddEventHandler("tpz_core:isPlayerReady", function()

	Wait(2000)

	local data = exports.tpz_core:getCoreAPI().GetPlayerClientData()

	if data == nil then
		return
	end

	PlayerJob = data.job
      
end)

-- Gets the player job when devmode set to true.
if Config.DevMode then
    Citizen.CreateThread(function ()

        Wait(2000)

        local data = exports.tpz_core:getCoreAPI().GetPlayerClientData()

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

        if TPZ.GetTableLength(Config.Locations) > 0 then

            local player       = PlayerPedId()
            local isEntityDead = IsEntityDead(player)

            local coords       = GetEntityCoords(player)
            local coordsDist   = vector3(coords.x, coords.y, coords.z)

            if not isEntityDead then
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
                            local hasRequiredJob = HasRequiredJob(locationConfig.Jobs)
    
                            if hasRequiredJob then 
                                StartTeleportationProcess(locationConfig.ExitCoords)
                            else
                                SendNotification(nil, Locales['NO_PERMISSIONS'], "error")
                            end
    
                            Wait(2000)
                        end
        
    
                    end
    
                    if #(coordsDist - exitCoords) <= locationConfig.TeleportActionDistance then
                        sleep = false
    
                        local promptGroup, promptList = GetPromptData()
    
                        local label = CreateVarString(10, 'LITERAL_STRING', locationConfig.PromptFooterLabel)
                        PromptSetActiveGroupThisFrame(promptGroup, label)
    
                        PromptSetText(promptList, CreateVarString(10, 'LITERAL_STRING', Locales['LEAVE']))
    
                        if PromptHasHoldModeCompleted(promptList) then
                            StartTeleportationProcess(locationConfig.EnterCoords)
                            Wait(3000)
                        end
        
    
                    end

                end


            end

        end

        if sleep then
            Wait(1500)
        end

    end

end)

