ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('police:server:showFingerprint')
AddEventHandler('police:server:showFingerprint', function(playerId)
    local src = source
    local Player = ESX.GetPlayerFromId(playerId)
    local identifier = Player.identifier
    
    TriggerClientEvent('police:client:showFingerprint', playerId, src)
    TriggerClientEvent('police:client:showFingerprint', src, playerId)
end)

RegisterServerEvent('police:server:showFingerprintId')
AddEventHandler('police:server:showFingerprintId', function(sessionId)
    local Player = ESX.GetPlayerFromId(sessionId)
    local identifier = Player.identifier
    local result = MySQL.Sync.fetchAll("SELECT fingerprint FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
    if result[1] ~= nil then
        local fid = result[1].fingerprint
        TriggerClientEvent('police:client:showFingerprintId', sessionId, fid)
        TriggerClientEvent('police:client:showFingerprintId', Player.source, fid)
    end
end)