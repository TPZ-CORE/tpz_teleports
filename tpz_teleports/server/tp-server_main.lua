local TPZ = {}

TriggerEvent("getTPZCore", function(cb) TPZ = cb end)

-----------------------------------------------------------
--[[ Functions  ]]--
-----------------------------------------------------------

-- @GetTableLength returns the length of a table.
local GetTableLength = function(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end


local HasRequiredJob = function(LocationIndex, CurrentJob)

    for _, job in pairs(Config.Locations[LocationIndex].Jobs) do 

        if job == CurrentJob then 
            return true
        end

    end

    return false

end

-----------------------------------------------------------
--[[ Events  ]]--
-----------------------------------------------------------

RegisterServerEvent("tpz_teleports:onEntrance")
AddEventHandler("tpz_teleports:onEntrance", function(targetCoords, locationId)
    local _source = source
    local xPlayer = TPZ.GetPlayer(source)

    local _id = tonumber(locationId)

    if (not Config.Locations[_id].Jobs) or (Config.Locations[_id].Jobs and GetTableLength(Config.Locations[_id].Jobs) <= 0) then
        TriggerClientEvent('tpz_teleports:StartTeleportationProcess', _source, targetCoords)
        return
    end

    local job    = xPlayer.getJob()
    local hasJob = HasRequiredJob(_id, job)

    if not hasJob then
        TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['NO_PERMISSIONS'], 3000)
        return
    end

    TriggerClientEvent('tpz_teleports:StartTeleportationProcess', _source, targetCoords)

end)

