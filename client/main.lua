local QBCore = exports['qb-core']:GetCoreObject()
local seatbeltOn = false

-- Imposta il GPS (Waypoint) di colore Arancione all'avvio
CreateThread(function()
    Wait(1000)
    SetBlipRouteColour(GetFirstBlipInfoId(8), 47) 
end)

-- Comando per aprire il menu impostazioni (/hud)
RegisterCommand('hud', function()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = "openMenu" })
end)

-- Callback quando chiudi il menu dal JS
RegisterNUICallback('closeMenu', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

-- Sistema Cintura (Premi 'B')
RegisterKeyMapping('toggleseatbelt', 'Metti/Togli Cintura', 'keyboard', 'B')
RegisterCommand('toggleseatbelt', function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        seatbeltOn = not seatbeltOn
        if seatbeltOn then
            QBCore.Functions.Notify(Lang:t("notify.seatbelt_on"), "success")
        else
            QBCore.Functions.Notify(Lang:t("notify.seatbelt_off"), "error")
        end
    end
end)

-- Loop Principale: Invia dati alla UI
CreateThread(function()
    while true do
        Wait(200) -- Aggiorna ogni 200ms
        
        local ped = PlayerPedId()
        local PlayerData = QBCore.Functions.GetPlayerData()

        -- PROTEZIONE: Esegui il codice SOLO se il giocatore è loggato e ha tutti i dati caricati
        if PlayerData and PlayerData.metadata and PlayerData.job and PlayerData.gang then
            
            -- Dati Player
            local health = GetEntityHealth(ped) - 100
            if health < 0 then health = 0 end -- Evita valori negativi buggati di GTA
            
            local armor = GetPedArmour(ped)
            local hunger = PlayerData.metadata["hunger"] or 0
            local thirst = PlayerData.metadata["thirst"] or 0
            local stress = PlayerData.metadata["stress"] or 0
            
            -- Lavoro e Gang
            local jobName = PlayerData.job.label .. " - " .. PlayerData.job.grade.name
            local gangName = PlayerData.gang.label
            local playerId = GetPlayerServerId(PlayerId())

            -- Bussola e Strada
            local coords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)
            local street1, _ = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
            local streetName = GetStreetNameFromHashKey(street1)
            
            local compass = "N"
            if heading >= 315 or heading < 45 then compass = "N"
            elseif heading >= 45 and heading < 135 then compass = "W"
            elseif heading >= 135 and heading < 225 then compass = "S"
            elseif heading >= 225 and heading < 315 then compass = "E" end

            -- Dati Veicolo
            local inVehicle = IsPedInAnyVehicle(ped, false)
            local speed = 0
            local fuel = 0

            if inVehicle then
                local veh = GetVehiclePedIsIn(ped, false)
                speed = math.ceil(GetEntitySpeed(veh) * 3.6) -- Da ms a km/h
                
                -- PROTEZIONE BENZINA: Prova a prendere LegacyFuel, se non c'è usa quello base di GTA
                local success, fuelLevel = pcall(function()
                    return exports['LegacyFuel']:GetFuel(veh)
                end)
                
                if success and fuelLevel then
                    fuel = math.ceil(fuelLevel)
                else
                    fuel = math.ceil(GetVehicleFuelLevel(veh))
                end
            else
                seatbeltOn = false -- Resetta cintura se scendi
            end

            -- INVIA TUTTO ALL'HTML
            SendNUIMessage({
                action = "updateHUD",
                health = health,
                armor = armor,
                hunger = hunger,
                thirst = thirst,
                stress = stress,
                job = jobName,
                gang = gangName,
                id = playerId,
                street = streetName,
                compass = compass,
                inVehicle = inVehicle,
                speed = speed,
                fuel = fuel,
                seatbelt = seatbeltOn
            })
        end
    end
end)