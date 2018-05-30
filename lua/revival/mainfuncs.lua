																		/************************************************************************
																				  Made by Loki611 (http://steamcommunity.com/id/Loki611)
																		***************************************************************************/

function REVIVAL.isInTable(tbl, val)
	for i = 1, #tbl do
		if(tbl[i] == v)then
			return true;
		end
	end
	return false;
end

function REVIVAL.revivePlayer(cli, force)
	local forceRespawn = force;
	
	local pointCost = REVIVAL.getSetting("pointsToRespawn", 0);
	local cashCost = REVIVAL.getSetting("costToRespawn", 0);
	local revivalChance = REVIVAL.getSetting("revivalChance", 100);
	local gotLucky = tobool(revivalChance >= math.random(0, 100));
	
	if(!gotLucky)then
		cli:SetNWInt("revival_failedtime", CurTime() + REVIVAL.getSetting("revivalFailedTextTime", 4));
		cli.playerCorpse.hasBeenRevived = false;
		cli.playerCorpse:SetNWBool("hasBeenRevived", false);
		return;
	end
	
	if(pointCost > 0 && cli.PS_HasPoints)then
		if(!cli:PS_HasPoints(pointCost))then 
			return;
		elseif(cli.PS_TakePoints)then
			cli:PS_TakePoints(pointCost);
		end
	end
	
	if(cashCost > 0 && cli.canAfford)then
		if(!cli:canAfford(cashCost))then 
			return; 
		elseif(cli.addMoney)then
			cli:addMoney(-cashCost);
		end
	end
	
	if(forceRespawn)then
		cli.deathPos = nil;
	end
	
	cli:reviveBody();
end

function REVIVAL.getSetting(setting, default)
	local retVal = default;
	if(REVIVAL[setting] != nil)then
		retVal = REVIVAL[setting];
	end
	
	return retVal;
end

function REVIVAL.notify(to, typ, delay, message)
	if(DarkRP && DarkRP.notify)then
		DarkRP.notify(to, typ, delay, message);
	else
		if(CLIENT)then
			GAMEMODE:AddNotify(message, typ, delay);
		elseif(SERVER)then
			if(type(to) == "table")then
				for _,v in pairs(to) do
					v:SendLua("GAMEMODE:AddNotify(\""..message.."\", "..typ..", "..delay..")");
				end
			elseif(type(to) == "Player")then
				to:SendLua("GAMEMODE:AddNotify(\""..message.."\", "..typ..", "..delay..")");
			end
		end
	end
end

function REVIVAL.getRangedTrace(pl, range)
	local traceRes = util.TraceLine({
		start = pl:EyePos(),
		endpos = pl:EyePos() + pl:EyeAngles():Forward() * range,
		filter = {pl}
	});
	return traceRes;
end