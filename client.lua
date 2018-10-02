local ignorePlayerNameDistance = false
local disPlayerOverhead = 20
local playerSource = 0
local playerGroup = nil
local ESX = nil
local showPlayerNumbers = false
local ignoreLineOfSight = false
local StaffTags = {}
local DirectorTags = {}

RegisterNetEvent("ToggleStaffTags")
AddEventHandler("ToggleStaffTags", function(id)
	if isAdmin() then
		if (FindPlayerStaff(id)) then
			for a = 1, #StaffTags do
				if StaffTags[a] == id then
					table.remove(StaffTags, id)
					break
				end
			end
		else
			table.insert(StaffTags, id)
		end
	end
end)

RegisterNetEvent("ToggleDirectorTags")
AddEventHandler("ToggleDirectorTags", function(id)
	if isDirector() then
		if (FindPlayerDirector(id)) then
			for a = 1, #DirectorTags do
				if DirectorTags[a] == id then
					table.remove(DirectorTags, id)
					break
				end
			end
		else
			table.insert(DirectorTags, id)
		end
	end
end)

RegisterNetEvent('showPlayerNumbers')
AddEventHandler('showPlayerNumbers', function()
	if isAdmin() then
		disPlayerOverhead = 20
		if showPlayerNumbers then 
			showPlayerNumbers = false
			ignoreLineOfSight = false
		else
			showPlayerNumbers = true
			ignoreLineOfSight = true
		end
	end
end)

RegisterNetEvent('setPlayerOverheadDistance')
AddEventHandler('setPlayerOverheadDistance', function(distance)
	ESX.TriggerServerCallback('NB:getUsergroup', function(group)
		playerGroup = group
		if isAdmin() then
			showPlayerNumbers = true
			ignoreLineOfSight = true
			disPlayerOverhead = tonumber(distance)
		end
	end)
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) 
			ESX = obj
			ESX.TriggerServerCallback('NB:getUsergroup', function(group)
				playerGroup = group
				Citizen.Trace("PlayerGroup: " .. playerGroup)
			end)
		end)
        Citizen.Wait(0)
    end
end)


function DrawText3D(x,y,z, text, r,g,b, a, scale)
 
    local onScreen,_x,_y=SetDrawOrigin(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    if onScreen then
        SetTextScale(0.1*scale, 0.1*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextScale(0.0, scale)
        SetTextColour(r, g, b, a)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
		ClearDrawOrigin()
    end
end

function DrawPlayerMarker(x, y, z, markerID, r, g, b, a)
    local onScreen,_x,_y=SetDrawOrigin(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

	if onScreen then
		DrawMarker(markerID, x, y, z, 0.0, 0, 180.0, 0, 0, 0, 1.0, 1.0, 1.0, r, g, b, a, 0, 0, 2, 0, 0, 0, 0)
		ClearDrawOrigin()
	end
end

function isAdmin()
	if playerGroup == 'admin' or playerGroup == 'superadmin' or playerGroup == 'owner' then
		return true
	else
		return false
	end
end

function isDirector()
	if playerGroup == 'superadmin' or playerGroup == 'owner' then
		return true
	else
		return false
	end
end

Citizen.CreateThread(function()
    while true do
        for i=0,99 do
            N_0x31698aa80e0223f8(i)
        end
		for id = 0, 32 do
			
			x1, y1, z1 = table.unpack( GetEntityCoords( GetPlayerPed( -1 ), true ) )
			x2, y2, z2 = table.unpack( GetEntityCoords( GetPlayerPed( id ), true ) )
			distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))
			
            if  ((NetworkIsPlayerActive( id )) and GetPlayerPed( id ) ~= GetPlayerPed( -1 )) then
			--if  true then
                ped = GetPlayerPed( id )
                blip = GetBlipFromEntity( ped )
 
				local visible = IsEntityVisible(GetPlayerPed( id ))

				if (visible) then
				
					if(ignorePlayerNameDistance) and HasEntityClearLosToEntity(GetPlayerPed(-1), GetPlayerPed(id), 17 ) then
						if NetworkIsPlayerTalking( id ) then
							DrawText3D(x2, y2, z2+1.5, GetPlayerServerId(id), 0,255,100, 1)
						else
							DrawText3D(x2, y2, z2+1.5, GetPlayerServerId(id), 0,100,255, 1)
						end
					end
	 
					--print(showPlayerNumbers)
	 
					if HasEntityClearLosToEntity(GetPlayerPed(-1), GetPlayerPed(id), 17 ) or ignoreLineOfSight then
						if not (ignorePlayerNameDistance) then
							if IsPedInAnyVehicle(ped) then
								if (distance < disPlayerOverhead) then
									if FindPlayerStaff(GetPlayerServerId(id)) then
										DrawText3D(x2, y2, z2+1.3, "ADMIN", 255,0,0,175, 0.6)
									end
					
									if FindPlayerDirector(GetPlayerServerId(id)) then
										DrawText3D(x2, y2, z2+1.3, "DIRECTOR", 153,50,204,175, 0.6)
									end

									if NetworkIsPlayerTalking( id ) then
										if isAdmin() and showPlayerNumbers then
											DrawText3D(x2, y2, z2+1.5, GetPlayerServerId(id).." - "..GetPlayerName(id), 0,255,100,130, 0.40) -- Draw green player number
										else
											DrawText3D(x2, y2, z2+1.8, "•", 0,255,100,175, 0.5) -- Draw green player dot
										end
									else
										if isAdmin() and showPlayerNumbers then
											DrawText3D(x2, y2, z2+1.5, GetPlayerServerId(id).." - "..GetPlayerName(id), 248,6,10,130, 0.40) -- Draw blue player number
										else
											DrawText3D(x2, y2, z2+1.8, "•", 0,100,255,175, 0.5) -- Draw blue player dot
										end
									end
								end
							else
								if (distance < disPlayerOverhead) then
									if FindPlayerStaff(GetPlayerServerId(id)) then
										DrawText3D(x2, y2, z2+1.3, "ADMIN", 255,0,0,175, 0.6)
									end
					
									if FindPlayerDirector(GetPlayerServerId(id)) then
										DrawText3D(x2, y2, z2+1.3, "DIRECTOR", 153,50,204,175, 0.6)
									end

									if NetworkIsPlayerTalking( id ) then
										if isAdmin() and showPlayerNumbers and (distance < disPlayerOverhead) then
											DrawText3D(x2, y2, z2+1.5, GetPlayerServerId(id).." - "..GetPlayerName(id), 0,255,100,130, 0.40) -- Draw green player number
										end
									else
										if isAdmin() and showPlayerNumbers and (distance < disPlayerOverhead) then
											DrawText3D(x2, y2, z2+1.5, GetPlayerServerId(id).." - "..GetPlayerName(id), 248,6,10,130, 0.40) -- Draw blue player number
										end
									end
								end
							end
						end
					end
				end
			else
				if FindPlayerStaff(GetPlayerServerId(id)) then
					DrawText3D(x2, y2, z2+1.3, "ADMIN", 255,0,0,175, 0.6)
				end

				if FindPlayerDirector(GetPlayerServerId(id)) then
					DrawText3D(x2, y2, z2+1.3, "DIRECTOR", 153,50,204,175, 0.6)
				end
			end
        end
        Citizen.Wait(0)
		
    end
end)

function FindPlayerStaff(id)
	for a = 1, #StaffTags do
		if StaffTags[a] == id then
			return true
		end
	end
	return false
end

function FindPlayerDirector(id)
	for a = 1, #DirectorTags do
		if DirectorTags[a] == id then
			return true
		end
	end
	return false
end