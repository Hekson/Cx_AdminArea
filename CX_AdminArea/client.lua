ESX = nil


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	SetNuiFocus(false, false)
end)

--- Config ---
misTxtDis = "~r~~h~Dar yek mantaghe az map RP pause ast lotfan vared mantaghe nashavid." -- Use colors from: https://gist.github.com/leonardosnt/061e691a1c6c0597d633

--- Code ---
local blips = {}
local coordsformarker = {}
function missionTextDisplay(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end
alredypause = true

RegisterNetEvent('getadminpos')
AddEventHandler("getadminpos", function(blip)
	local pos = GetEntityCoords(PlayerPedId())
	local blip = blip
	local id = source
	ESX.TriggerServerCallback('setada', function()
	end, blip, pos, id)
end)

RegisterNetEvent('AdminAreaSet')
AddEventHandler("AdminAreaSet", function(blip, s, pos)
    if s ~= nil then
        src = s
        coords = pos
    else
        coords = blip.coords
    end 
    coordsformarker[blip.index] =  coords
    if not blips[blip.index] then
        blips[blip.index] = {}
    end

    if not givenCoords then
        TriggerServerEvent('AdminArea:setCoords', tonumber(blip.index), coords)
    end


    blips[blip.index]["blip"] = AddBlipForCoord(coords.x, coords.y, coords.z)
    blips[blip.index]["radius"] = AddBlipForRadius(coords.x, coords.y, coords.z, blip.radius)
    SetBlipSprite(blips[blip.index].blip, blip.id)
    SetBlipAsShortRange(blips[blip.index].blip, true)
    SetBlipColour(blips[blip.index].blip, blip.color)
    SetBlipScale(blips[blip.index].blip, 1.0)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(blip.name)
    EndTextCommandSetBlipName(blips[blip.index].blip)
    blips[blip.index]["coords"] = vector3(coords.x, coords.y, coords.z - 10)
    blips[blip.index]["radius2"] = blip.radius
    SetBlipAlpha(blips[blip.index]["radius"], 80)
    SetBlipColour(blips[blip.index]["radius"], blip.color)
	if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), blips[blip.index]["coords"], true) < 40.000 then
		missionTextDisplay(misTxtDis, 8000)
 	end
	while blips[blip.index] do
	    Wait(0)
		if blips[blip.index] ~= nil then
			DrawMarker(1, blips[blip.index]["coords"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, blip.radius, blip.radius, 200.0, 205, 226, 255, 100, false, true, 2, false, false, false, false)
		end
	end
end)

function RGBRainbow(frequency)
    local result = {}
    local curtime = GetGameTimer() / 1000

    result.r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)
    result.g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)
    result.b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)

    return result
end

RegisterNetEvent('AdminAreaClear')
AddEventHandler("AdminAreaClear", function(blipID)
    if blips[blipID] then
        missionTextDisplay("RP Dar mantaghe ~o~Admin Area(" .. blipID .. ")~r~ unpause ~w~shod!", 5000)
        RemoveBlip(blips[blipID].blip)
        RemoveBlip(blips[blipID].radius)
        blips[blipID] = nil
    else
        print("There was a issue with removing blip: " .. tostring(blipID))
    end
end)

function SafeZoneText(x,y,z, text,scl) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, true)
 
    local scale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString("~a~"..text)
        DrawTexet(_x,_y)
    end
end

Citizen.CreateThread(function()
    SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0)
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(1)
		if IsPedOnFoot(GetPlayerPed(-1)) then 
			SetRadarZoom(1100)
		elseif IsPedInAnyVehicle(GetPlayerPed(-1), true) then
			SetRadarZoom(1100)
		end
    end
end)


--no ped and vehicle
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		SetVehicleDensityMultiplierThisFrame(0.0)
		SetPedDensityMultiplierThisFrame(0.0)
		SetRandomVehicleDensityMultiplierThisFrame(0.0)
		SetParkedVehicleDensityMultiplierThisFrame(0.0)
		SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
		SetGarbageTrucks(false)
		SetRandomBoats(false)
		RemovePeskyVehicles(player, 3000.0)
		SetCreateRandomCops(false)
		SetPlayerWantedLevel(PlayerId(), 0, false)
		SetPlayerWantedLevelNow(PlayerId(), false)
		SetCreateRandomCopsNotOnScenarios(false)
		SetCreateRandomCopsOnScenarios(false)
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
		ClearAreaOfVehicles(x, y, z, 1000, false, false, false, false, false)
        DisablePlayerVehicleRewards(PlayerId())
		RemoveVehiclesFromGeneratorsInArea(x - 500.0, y - 500.0, z - 500.0, x + 500.0, y + 500.0, z + 500.0);
	end
end)


function RemovePeskyVehicles(player, range)
    local pos = GetEntityCoords(playerPed)
    RemoveVehiclesFromGeneratorsInArea(
        pos.x - range, pos.y - range, pos.z - range,
        pos.x + range, pos.y + range, pos.z + range
    );
end

local passengerDriveBy = true



