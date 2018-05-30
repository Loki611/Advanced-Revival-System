																		/************************************************************************
																				  Made by Loki611 (http://steamcommunity.com/id/Loki611)
																		***************************************************************************/

surface.CreateFont("REVIVAL_RespawnFont", {
	font = "Arial",
	size = ScreenScale(18),
	weight = 800
})

surface.CreateFont("REVIVAL_DeathFont", {
	font = "Arial",
	size = ScreenScale(16),
	weight = 800
})

surface.CreateFont("REVIVAL_FailedFont", {
	font = "Arial",
	size = ScreenScale(16),
	weight = 800
})

surface.CreateFont("REVIVAL_NotEnoughLootFont", {
	font = "Arial",
	size = 120,
	weight = 600
})

hook.Add("Think", "revival_think_cl", function()
	/*if(input.IsKeyDown(REVIVAL.getSetting("alertKey", nil)) && !cli:Alive())then
		net.Start("revival_revive_alerted");
		net.SendToServer();
	end*/
	local pl = LocalPlayer();
	
	local barWidth = 50;
	local target = (barWidth / 10);
	local smallBar = (barWidth / 50);
	
	pl.reviveX = pl.reviveX || -25;
	pl.resetTargetColor = pl.resetTargetColor || CurTime();
		
	local scaledArrowSpeed = (1280 / ScrW()) * REVIVAL.getSetting("arrowSpeed", 40) * FrameTime();
		
	if(pl.reviveOrder || false)then
		pl.reviveX = pl.reviveX + scaledArrowSpeed;
	else
		pl.reviveX = pl.reviveX - scaledArrowSpeed;
	end
			
	if(pl.reviveX + (barWidth / 50) >= barWidth / 2.15)then
		pl.reviveOrder = false;
	elseif(pl.reviveX <= -barWidth / 2.15)then
		pl.reviveOrder = true;
	end
	
	if(pl.reviveTargetColor && (pl.resetTargetColor || CurTime()) < CurTime())then
		pl.reviveTargetColor = nil;
	end
	
	if(input.IsKeyDown(KEY_E) && !pl.reviveUsed)then
		if(pl.reviveX > -(target/2) && pl.reviveX < target/2)then
			net.Start("revival_revive_gottarget");
			net.SendToServer();
			pl.reviveTargetColor = Color(0, 255, 0);
			pl.resetTargetColor = CurTime() + 0.2;
		else
			net.Start("revival_revive_misstarget");
			net.SendToServer();
			pl.reviveTargetColor = Color(255, 0, 0);
			pl.resetTargetColor = CurTime() + 0.2;
		end
		
		pl.reviveUsed = true;
	elseif(!input.IsKeyDown(KEY_E) && pl.reviveUsed)then
		pl.reviveUsed = false;
	end
end)

hook.Add("HUDPaint", "revival_hud_paint", function()
	local pl = LocalPlayer();
	
	if(REVIVAL.getSetting("useTeamWhitelist", false) && !REVIVAL.isInTable(REVIVAL.teamWhitelist, pl:Team()))then return; end
	
	if(!pl:Alive())then
		if(REVIVAL.getSetting("showRespawnText", false))then
			local diff = math.Clamp((pl:GetNWInt("respawnTime", CurTime()) - CurTime()), 0, 99999999999);
			local niceTime = string.NiceTime(diff);
			local respawnText = REVIVAL.getSetting("respawnText", "Respawning");
			
			if(diff == 0)then
				respawnText = REVIVAL.getSetting("respawnAfterTimeText", "Respawn");
				niceTime = "";
			end
			
			if(REVIVAL.getSetting("shouldUseMurderSetting", false) && (GAMEMODE.IsCSpectating != nil && !GAMEMODE:IsCSpectating()))then
				draw.SimpleText(respawnText, "REVIVAL_RespawnFont", ScrW() / 2, ScrH() / 18, REVIVAL.getSetting("respawnTextColor", Color(255, 255, 255)), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP);
				draw.SimpleText(string.Replace(REVIVAL.getSetting("respawnTimeText", "{TIME}"), "{TIME}", niceTime), "REVIVAL_RespawnFont", ScrW() / 2, ScrH() / 10, REVIVAL.getSetting("respawnTimeColor", Color(255, 255, 255)), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP);
			else
				draw.SimpleText(respawnText, "REVIVAL_RespawnFont", ScrW() / 2, ScrH() / 18, REVIVAL.getSetting("respawnTextColor", Color(255, 255, 255)), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP);
				draw.SimpleText(string.Replace(REVIVAL.getSetting("respawnTimeText", "{TIME}"), "{TIME}", niceTime), "REVIVAL_RespawnFont", ScrW() / 2, ScrH() / 10, REVIVAL.getSetting("respawnTimeColor", Color(255, 255, 255)), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP);
			end
		end
		
		if(LocalPlayer():GetNWInt("revival_failedtime", CurTime()) > CurTime())then
			local flashColr =  REVIVAL.getSetting("revivalFailedFlash", Color(255, 0, 0));
			local glowR = math.abs(math.sin(CurTime() * 2) * flashColr.r);
			local glowG = math.abs(math.sin(CurTime() * 2) * flashColr.g);
			local glowB = math.abs(math.sin(CurTime() * 2) * flashColr.b);
			
			local col = Color(glowR, glowG, glowB);
						
			draw.SimpleText(REVIVAL.getSetting("revivalFailedText", "REVIVAL FAILED"), REVIVAL.getSetting("revivalFailedTextFont", "REVIVAL_FailedFont"), ScrW() / 2, ScrH() / 10, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP);
		end
	
	elseif(REVIVAL.getSetting("alertedTypes", {})[ALERT_VISUAL] || false)then
		if(!REVIVAL.getSetting("alertedTeams", {})[pl:Team()])then return; end
		
		local flashColor = REVIVAL.getSetting("alertFlashColor", Color(200, 0, 0));
		for _, v in pairs(player.GetAll())do
			if(!v:Alive() && v:GetNWEntity("playerCorpse", nil):IsValid())then
				local plypos = (v:GetNWEntity("playerCorpse"):GetPos() + Vector(0,0,60)):ToScreen();
				draw.SimpleText("DEAD", "REVIVAL_DeathFont", plypos.x, plypos.y, Color(math.abs(math.sin(CurTime() * 2) * flashColor.r), math.abs(math.sin(CurTime() * 2) * flashColor.g), math.abs(math.sin(CurTime() * 2) * flashColor.b)), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP);
			end
		end
	end
end)

hook.Add("PostDrawOpaqueRenderables", "revival_postdrawrenders", function()
	local pl = LocalPlayer();
	
		
	if(REVIVAL.getSetting("useTeamWhitelist", false) && !REVIVAL.isInTable(REVIVAL.teamWhitelist, pl:Team()))then return; end
	
	
	if(REVIVAL.getSetting("canSeeBodyInfo", true))then	
		local traceRes = REVIVAL.getRangedTrace(pl, REVIVAL.getSetting("reviveRange", 100));
		local traceEnt = traceRes.Entity;

		if (IsValid(traceEnt) && traceEnt:GetClass() == "prop_ragdoll" && traceEnt:GetNWBool("isPlayerCorpse", false) && IsValid(traceEnt:GetOwner()))then
			if(traceEnt:GetOwner() == pl)then return; end
			if(traceEnt:GetNWBool("hasBeenRevived", false))then return; end
			
			if(REVIVAL.getSetting("shouldUseMurderSetting", false) && (GAMEMODE.LootCollected != nil && GAMEMODE.LootCollected < REVIVAL.getSetting("lootCost", 0)))then
				local plypos = (traceEnt:GetPos() + Vector(0,0,40));
				local plAng = pl:GetAngles() + Angle(140, 80, -90);
				
				pl.reviveX = pl.reviveX || -25;
				cam.Start3D2D(plypos, plAng, 0.1);
					draw.SimpleText(REVIVAL.getSetting("notEnoughLootText", "Not enough loot!"), REVIVAL.getSetting("notEnoughLootTextFont", "REVIVAL_NotEnoughLootFont"), 2, 2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
					draw.SimpleText(REVIVAL.getSetting("notEnoughLootText", "Not enough loot!"), REVIVAL.getSetting("notEnoughLootTextFont", "REVIVAL_NotEnoughLootFont"), 0, 0, REVIVAL.getSetting("notEnoughLootTextColor", Color(200, 0, 200)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
				cam.End3D2D();
			else
				local barWidth = 50;
				local plypos = (traceEnt:GetPos() + Vector(0,0,10));
				local plAng = pl:GetAngles();
				local maxCompressions = REVIVAL.getSetting("compressionCount", 8);
				local compressions = pl:GetNWInt("revival_Compressions", 0);
				local compDif = compressions / maxCompressions;
				
				plAng[1] = -plAng[1];
				pl.reviveX = pl.reviveX || -25;
				cam.Start3D2D(plypos, plAng, 1);
					draw.RoundedBox(1, 16, -barWidth / 2, 8, barWidth, REVIVAL.getSetting("backBarColor", Color(0, 0, 0)));
					draw.RoundedBox(0, 16, -((barWidth / 10) / 2), 8, (barWidth / 10), pl.reviveTargetColor || Color(0, 255, 255));
					draw.RoundedBox(1, 16, -((barWidth / 50) / 2) + pl.reviveX, 8, barWidth / 50, REVIVAL.getSetting("arrowColor", Color(255, 0, 0)));
					
					draw.RoundedBox(1, 24, -barWidth/2, 1.5, barWidth, REVIVAL.getSetting("comprssionBarBackColor", Color(0, 0, 0)));
	
					if(compDif != 0)then
						draw.RoundedBox(1, 24, -barWidth/2, 1.5, barWidth * compDif, REVIVAL.getSetting("comprssionBarColor", Color(200, 0, 200)));
					end
				cam.End3D2D();
			end
		end
	end
end)

hook.Add("RenderScreenspaceEffects", "revive_render_screen_effects", function()
	if(!LocalPlayer():Alive() && (GAMEMODE.IsCSpectating == nil && true || (GAMEMODE.IsCSpectating != nil && (!GAMEMODE:IsCSpectating() || REVIVAL.getSetting("showDeathEffectWhileSpectating", false)))) && REVIVAL.getSetting("deathScreenEffect", true))then // Default true because I like it.
		local effectColor = REVIVAL.getSetting("deathScreenColor", Color(200, 0, 0));
		local tab = {};
		tab["$pp_colour_addr"] = effectColor.r / 255;
		tab["$pp_colour_addg"] = effectColor.g / 255;
		tab["$pp_colour_addb"] = effectColor.b / 255;
		tab["$pp_colour_brightness"] = 0.5;
		tab["$pp_colour_contrast"] = 0.5;
		tab["$pp_colour_colour"] = 1;
		tab["$pp_colour_mulr"] = 0.2;
		tab["$pp_colour_mulg"] = 0.2;
		tab["$pp_colour_mulb"] = 0.2;
		
		DrawColorModify(tab);
		DrawMotionBlur(0.2, 0.8, 0.04);
	end
end)