ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob",function(job)
    ESX.PlayerData.job = job
end)

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    while true do
        local wait = 1000
        local pos = GetEntityCoords(PlayerPedId())
        for k, v in pairs(Config.Locations["fingerprint"]) do
            if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 4.5) then
                wait = 0
                if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 1.5) then
                    DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Parmak izi tara")
                    if IsControlJustReleased(0, 46) then
                        local player, distance = ESX.Game.GetClosestPlayer()
                        if player ~= -1 and distance <= 2.5 then
                            local playerId = GetPlayerServerId(player)
                            TriggerServerEvent("police:server:showFingerprint", playerId)
                        else
                        TriggerEvent("notification", "Etrafta kimse yok!")
                        end
                    end
                elseif (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 2.5) then
                    DrawText3D(v.x, v.y, v.z, "Parmak izi tara")
                end  
            end
        end
        Citizen.Wait(wait)
    end
end)

local inFingerprint = false
local FingerPrintSessionId = nil

RegisterNetEvent('police:client:showFingerprint')
AddEventHandler('police:client:showFingerprint', function(playerId)
    openFingerprintUI()
    FingerPrintSessionId = playerId
end)


RegisterNetEvent('police:client:showFingerprintId')
AddEventHandler('police:client:showFingerprintId', function(fid)
    SendNUIMessage({
        type = "updateFingerprintId",
        fingerprintId = fid
    })
    PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
end)

RegisterNUICallback('doFingerScan', function(data)
    TriggerServerEvent('police:server:showFingerprintId', FingerPrintSessionId)
end)

function openFingerprintUI()
    SendNUIMessage({
        type = "fingerprintOpen"
    })
    inFingerprint = true
    SetNuiFocus(true, true)
end

RegisterNUICallback('closeFingerprint', function()
    SetNuiFocus(false, false)
    inFingerprint = false
end)