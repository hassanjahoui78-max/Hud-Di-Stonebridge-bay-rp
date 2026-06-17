local Player = exports.qbx_core:GetPlayer(source)

hidehudcomponents(2) -- armi

CreateThread(function()
    while true do
        Wait(200) -- Aggiorna 5 volte al secondo
        local playerPed = PlayerPedId()
        
        -- Dati Giocatore (Lavoro, Gang)
        local PlayerData = QBCore.Functions.GetPlayerData()
        
        -- Se sei in un veicolo
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local speed = GetEntitySpeed(vehicle) * 3.6 -- Da ms a km/h
            local fuel = exports['LegacyFuel']:GetFuel(vehicle) -- Dipende dal tuo script benzina
            
            SendNUIMessage({
                action = "updateCar",
                inCar = true,
                speed = speed,
                fuel = fuel
                -- La cintura richiede uno script a parte che invii true/false
            })
        else
            SendNUIMessage({
                action = "updateCar",
                inCar = false
            })
        end
    end
end)

CreateThread(function()
    -- Questa nativa cambia il colore del tracciato Waypoint
    -- Il codice colore 47 è l'arancione in GTA V
    SetBlipRouteColour(GetFirstBlipInfoId(8), 47) 
    
    -- In alternativa, per forzare i colori dell'HUD nativo (HUD_COLOUR_ORANGE)
    ReplaceHudColourWithRgba(142, 255, 159, 67, 255) 
end)
