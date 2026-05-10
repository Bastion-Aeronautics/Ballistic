PORT = property.getNumber("HTTP Port")
ID = property.getNumber("Track ID")
HTTP_cooldown = 10

-- Tick function that will be executed every logic tick
function onTick()
	HTTP_cooldown = HTTP_cooldown - 1
	
	if input.getBool(1) and HTTP_cooldown == 0  then
		async.httpGet(PORT, '/updatePosition?x='..input.getNumber(1)..'&y='..input.getNumber(2)..'&z='..input.getNumber(3)..'&id='..ID)
    end
	
	if HTTP_cooldown == 0 then HTTP_cooldown = 10 end
end