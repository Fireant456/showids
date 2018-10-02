function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

AddEventHandler('chatMessage', function(source, n, msg)
	msg = string.lower(msg)
		
	if string.starts(msg, "/showids") then
		if(msg == "/showids") then
			CancelEvent()
			Citizen.Wait(0)
			TriggerClientEvent('showPlayerNumbers', source)
		else
			local words = {}
			for word in msg:gmatch("%w+") do table.insert(words, word) end
			
			TriggerClientEvent('setPlayerOverheadDistance', source, words[2])
		end
	end
	if string.starts(msg, "/staff") then
		if(msg == "/staff") then
			CancelEvent()
			Citizen.Wait(0)
			TriggerClientEvent("ToggleStaffTags", -1, source)
		end
	end
	if string.starts(msg, "/director") then
		if(msg == "/director") then
			CancelEvent()
			Citizen.Wait(0)
			TriggerClientEvent("ToggleDirectorTags", -1, source)
		end
	end
end)

RegisterServerEvent("eventName")