local isInGreenzone = false

function IsPlayerInGreenzone()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    return #(playerCoords - Config.config.ZoneCoords) < Config.config.ZoneRadius
end

function DisableCollisions(disable)
    local playerPed = PlayerPedId()
    SetEntityCollision(playerPed, not disable, not disable)
end

function BlockKeys(disable)
    for _, key in pairs(Config.config.BlockedKeys) do
        DisableControlAction(0, key, disable)
    end
end

function ShowNativeMessage(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(message)
    DrawNotification(false, true)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        DrawSphere(Config.config.ZoneCoords.x, Config.config.ZoneCoords.y, Config.config.ZoneCoords.z, Config.config.ZoneRadius, Config.config.ZoneColor.r, Config.config.ZoneColor.g, Config.config.ZoneColor.b, Config.config.ZoneColor.opacity)

        local inGreenzone = IsPlayerInGreenzone()

        if inGreenzone and not isInGreenzone then
            isInGreenzone = true
            ShowNativeMessage(Config.config.EnterText)

            if Config.config.DisableCollisions then
                DisableCollisions(true)
            end

            if Config.config.DisableKeys then
                BlockKeys(true)
            end
        elseif not inGreenzone and isInGreenzone then
            isInGreenzone = false
            ShowNativeMessage(Config.config.LeaveText)

            if not Config.config.DisableCollisions then
                DisableCollisions(false)
            end

            if not Config.config.DisableKeys then
                BlockKeys(false)
            end
        end

        if isInGreenzone and Config.config.DisableKeys then
            for _, key in pairs(Config.config.BlockedKeys) do
                DisableControlAction(0, key, disable)
            end
        end
    end
end)


