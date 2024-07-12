local ESX = exports['es_extended']:getSharedObject()
local config = json.decode(LoadResourceFile(GetCurrentResourceName(), 'config.json'))

RegisterCommand('phonetrack', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        print("Error: Player object not found")
        return
    end

    local roleAuthorized = false

    for _, role in ipairs(config.authorized_roles) do
        if xPlayer.job.name == role then
            roleAuthorized = true
            break
        end
    end

    if not roleAuthorized then
        TriggerClientEvent('esx:showNotification', source, config.messages.no_permission)
        return
    end

    local phoneNumber = args[1]
    if not phoneNumber then
        TriggerClientEvent('esx:showNotification', source, config.messages.no_phone_number)
        return
    end

    MySQL.Async.fetchScalar('SELECT identifier FROM users WHERE phone_number = @phone_number', {
        ['@phone_number'] = phoneNumber
    }, function(identifier)
        if not identifier then
            TriggerClientEvent('esx:showNotification', source, config.messages.number_not_found)
        else
            local roll = math.random(1, 100)
            if roll < config.tracking.success_threshold then
                TriggerClientEvent('esx:showNotification', source, config.messages.number_not_found)
            else
                TriggerClientEvent('esx:showNotification', source, config.messages.tracking_success)
                TriggerEvent('phonetrack:getPlayerLocation', source, identifier)
            end
        end
    end)
end)

RegisterNetEvent('phonetrack:getPlayerLocation')
AddEventHandler('phonetrack:getPlayerLocation', function(source, identifier)
    local targetPlayer = ESX.GetPlayerFromIdentifier(identifier)

    if targetPlayer then
        local targetCoords = GetEntityCoords(GetPlayerPed(targetPlayer.source))
        TriggerClientEvent('phonetrack:createBlip', source, targetCoords)
    else
        TriggerClientEvent('esx:showNotification', source, config.messages.number_not_found)
    end
end)
