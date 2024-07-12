local config = json.decode(LoadResourceFile(GetCurrentResourceName(), 'config.json'))
local blipCoords = nil

RegisterNetEvent('phonetrack:createBlip')
AddEventHandler('phonetrack:createBlip', function(playerCoords)
    print("Creating blip at coordinates: " .. tostring(playerCoords))
    blipCoords = playerCoords
    local blip = AddBlipForCoord(playerCoords.x, playerCoords.y, playerCoords.z)
    SetBlipSprite(blip, config.tracking.blip.type)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, config.tracking.blip.size)
    SetBlipColour(blip, config.tracking.blip.color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Tracked Phone")
    EndTextCommandSetBlipName(blip)
    
    Citizen.Wait(config.tracking.blip.duration * 1000)
    print("Removing blip")
    RemoveBlip(blip)
    blipCoords = nil
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if blipCoords ~= nil then
            DisplayHelpText("Press ~INPUT_CONTEXT~ to set a waypoint to the tracked phone's location")
            if IsControlJustReleased(0, 38) then -- "E" key
                SetNewWaypoint(blipCoords.x, blipCoords.y)
            end
        end
    end
end)

function DisplayHelpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
