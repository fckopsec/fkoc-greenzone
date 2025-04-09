local greenZones = {
    {x = 200.0, y = 200.0, z = 20.0, radius = 50.0}, -- Example Green Zone
    {x = 300.0, y = 300.0, z = 20.0, radius = 75.0}  -- Add more zones as needed
}

-- Function to check if a player is in a green zone
local function isPlayerInGreenZone(playerCoords)
    for _, zone in ipairs(greenZones) do
        local distance = #(playerCoords - vector3(zone.x, zone.y, zone.z))
        if distance <= zone.radius then
            return true
        end
    end
    return false
end

-- Prevent shooting in green zones
AddEventHandler('entityCreating', function(entity)
    local entityType = GetEntityType(entity)
    if entityType == 1 then -- Check if it's a ped
        local pedOwner = NetworkGetEntityOwner(entity)
        if pedOwner then
            local playerCoords = GetEntityCoords(GetPlayerPed(pedOwner))
            if isPlayerInGreenZone(playerCoords) then
                CancelEvent()
            end
        end
    end
end)

-- Prevent vehicle damage in green zones
AddEventHandler('entityDamaged', function(entity, attacker)
    if DoesEntityExist(entity) and IsEntityAVehicle(entity) then
        local attackerCoords = GetEntityCoords(attacker)
        if isPlayerInGreenZone(attackerCoords) then
            CancelEvent()
        end
    end
end)

-- Prevent melee attacks in green zones
AddEventHandler('playerMeleeHit', function(attacker, victim)
    local attackerCoords = GetEntityCoords(GetPlayerPed(attacker))
    if isPlayerInGreenZone(attackerCoords) then
        CancelEvent()
    end
end)