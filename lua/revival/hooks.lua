																		/************************************************************************
																				  Made by Loki611 (http://steamcommunity.com/id/Loki611)
																		***************************************************************************/

hook.Add("Revival_onPlayerRevived", "revival_player_Revived", function(pl)
	//gamemode.Call("PlayerLoadout", pl);
end)

hook.Add("PlayerSpawn", "revival_player_spawn", function(pl)
	if(pl.playerCorpse)then
		pl.deathPos = pl.playerCorpse:GetPos();
		pl:SetNWEntity("playerCorpse", nil);
		SafeRemoveEntity(pl.playerCorpse);
	end
end)

hook.Add("KeyPress", "revival_player_keypress", function(pl, keyCode)
	if(keyCode == IN_USE)then
		pl.lastUseE = CurTime();
		
		local traceRes = REVIVAL.getRangedTrace(pl, REVIVAL.getSetting("reviveRange", 96));
		local traceEnt = traceRes.Entity;
		local useMurder = REVIVAL.getSetting("shouldUseMurderSetting", false);
		local lootCost = REVIVAL.getSetting("lootCost", 0);
	
		if(IsValid(traceEnt) && traceEnt:GetClass() == "prop_ragdoll" && traceEnt.isPlayerCorpse && IsValid(traceEnt:GetOwner()))then
			if(traceEnt:GetOwner() == pl)then return; end
			if(useMurder && pl:GetLootCollected() < lootCost)then return; end
	
			if(!traceEnt.hasBeenRevived)then
				if(pl.lastUseCorpse == nil || pl.lastUseCorpse == traceEnt)then
					if(REVIVAL.useTeamWhitelist && !table.HasValue(REVIVAL.teamWhitelist, pl:Team()))then
						
					else				
						if(pl:GetNWInt("revival_Compressions", 0) >= REVIVAL.getSetting("compressionCount", 8))then
							if(useMurder)then
								pl:SetLootCollected(pl:GetLootCollected() - lootCost);
							end
							
							if(REVIVAL.getSetting("forceRevivalAccept", false))then
								REVIVAL.revivePlayer(traceEnt:GetOwner(), !REVIVAL.reviveAtDeath);
							else
								// Revived
								net.Start("revival_revive_menu");
									net.WriteEntity(pl);
								net.Send(traceEnt:GetOwner());
							end
							pl:SetNWInt("revival_Compressions", 0);
							traceEnt.hasBeenRevived = true;
							traceEnt:SetNWBool("hasBeenRevived", true);
							
							pl:ChatPrint(REVIVAL.getSetting("CPRFinished", "I think he's alive."));
						end
					end
				end
				
				if(REVIVAL.getSetting("canDragBodies", true))then
					if(traceEnt.beingDragged)then return; end
					
					local entIndex = pl:EntIndex();  
					local helpText = "";
					
					if(!pl.lastUseCorpse || pl.lastUseCorpse != traceEnt)then
						pl.lastUseCorpse = nil;
						helpText = REVIVAL.getSetting("helpText", "Hold E to drag the corpse.");
					end
					
					traceEnt.beingDragged = true;
					pl:ChatPrint(string.Replace(helpText, "{PLAYERNAME}", traceEnt:GetOwner():Nick() || ""));
					
					local cnt = 0;
					local tlt = REVIVAL.getSetting("dragLength", 6) * 10;
					timer.Create(entIndex..":CorpseDrag", 0.1, tlt, function()
						cnt = cnt + 1;
						if(!IsValid(pl) || !IsValid(traceEnt) || !pl:KeyDown(IN_USE) || cnt >= tlt)then
							timer.Destroy(entIndex .. ":CorpseDrag");
							traceEnt.beingDragged = false;
							return;
						end
						
						local physBone = traceRes.PhysicsBone;
						local targetPos = REVIVAL.getRangedTrace(pl, REVIVAL.getSetting("reviveRange", 96)).HitPos;
						local physObj = traceEnt:GetPhysicsObjectNum(physBone);
						physObj:SetVelocity((targetPos - traceEnt:GetPhysicsObjectNum(physBone):GetPos()) * 15);
					end)
				end
				
				pl.lastUseCorpse = traceEnt;
			end
		end
	end
end)

hook.Add("PlayerDeath", "revival_player_death", function(pl)
	local dmgs = REVIVAL.getSetting("customRespawnTimes", {});
	local rspTime = REVIVAL.getSetting("respawnTime", 12);
	
	local customTime = dmgs[pl.deathDmgType];
	if(pl.deathDmgType && customTime != nil)then
		if(type(customTime) == "number")then
			rspTime = customTime;
		end
	end
	
	local hookTime = hook.Call("Revival_OnRespawnTime", nil, pl, rspTime);
	if(hookTime != nil)then
		if(type(hookTime) == "number")then
			rspTime = rspTime + hookTime;
		end
	end
	
	pl.respawnTime = CurTime() + rspTime;
	pl:SetNWInt("respawnTime", pl.respawnTime);
	
	if(pl:GetRagdollEntity())then
		// Removes Gmods ragdoll. "Safely"
		SafeRemoveEntity(pl:GetRagdollEntity());
	end
	
	// Make dead body here.
	pl:makeDeadBody(pl:GetPos());
	pl.deathDmgType = nil;
	
	hook.Call("Revival_OnCorpseMade", nil, pl, pl.playerCorpse, rspTime);
end)

hook.Add("DoPlayerDeath", "revival_player_ondeath", function(pl, att, dmg)
	pl.deathDmgType = dmg:GetDamageType();
end)

hook.Add("PlayerDeathThink", "revival_player_deaththink", function(pl)
	if(pl.respawnTime && CurTime() < pl.respawnTime)then
		return false;
	elseif(pl.playerCorpse && REVIVAL.getSetting("removeBodyOnTime", false))then
		SafeRemoveEntity(pl.playerCorpse);
	end
end)

hook.Add("PlayerDisconnected", "revival_player_disconnect", function(pl)	
	if(pl.playerCorpse)then
		pl:SetNWEntity("playerCorpse", nil);
		SafeRemoveEntity(pl.playerCorpse);
	end
end)

hook.Add("Revival_OnCorpseMade", "revival_corpse_made", function(_,_,_)
end)