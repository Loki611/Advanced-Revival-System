																		/************************************************************************
																				  Made by Loki611 (http://steamcommunity.com/id/Loki611)
																		***************************************************************************/
																		

local _R = debug.getregistry();
local PLAYER = _R.Player;
local ENTITY = _R.Entity;

function ENTITY:isRagdoll()
	return self:IsValid() && self:GetClass() == "prop_ragdoll";
end

if(SERVER)then
	function PLAYER:requestRevive(reviver)
		net.Start("revival_revive_menu");
			net.WriteEntity(reviver);
		net.Send(self);
	end

	function PLAYER:makeDeadBody(pos) 
		if(IsValid(self.playerCorpse))then return end
		self.playerCorpse = ents.Create("prop_ragdoll")
		self.playerCorpse:SetModel(((REVIVAL.getSetting("skeletonOnDeath", false) && "models/player/skeleton.mdl") || self:GetModel()));
		self.playerCorpse:SetPos(pos);
		self.playerCorpse:SetAngles(self:GetAngles());
		self.playerCorpse:SetOwner(self);
		self.playerCorpse:Spawn();
		self.playerCorpse:Activate();
		self.playerCorpse.isPlayerCorpse = true;
		self.playerCorpse:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER);
		self.playerCorpse.ownerSteamID = self:SteamID();

		self:SetNWEntity("playerCorpse", self.playerCorpse);
		self.playerCorpse:SetNWBool("isPlayerCorpse", true);
		self.playerCorpse:SetNWBool("hasBeenRevived", false);
		
		local playerCorpse = self.playerCorpse;
		local playerCorpseIndex = playerCorpse:EntIndex();
		local playerCorpseColor = self:GetPlayerColor();
		
		playerCorpse.GetPlayerColor = function() return playerCorpseColor; end
		
		// I guess this time...
		timer.Simple(1, function()
			BroadcastLua("Entity("..playerCorpseIndex..").GetPlayerColor = function( ) return Vector( "..playerCorpseColor.x..", "..playerCorpseColor.y..", ".. playerCorpseColor.z.." ) end");
		end)

		self:StripWeapons();
		self:Spectate(OBS_MODE_CHASE);
		self:SpectateEntity(self.playerCorpse);
		
		if(REVIVAL.getSetting("shouldUseMurderSetting", false))then
			// Handle murder colors, names, values, etc.
			self:SetNWEntity("DeathRagdoll", playerCorpse )
			playerCorpse:SetNWEntity("RagdollOwner", self)
			table.insert(self.DeathRagdolls,playerCorpse)
			table.insert(GAMEMODE.DeathRagdolls,playerCorpse)
			
			if playerCorpse.SetPlayerColor then
				playerCorpse:SetPlayerColor(self:GetPlayerColor())
			end
			playerCorpse.PlayerRagdoll = true
			playerCorpse:SetBystanderName(self:GetBystanderName())
		end
		
		local physObj = self.playerCorpse:GetPhysicsObject();
		if(physObj)then
			// Simulate additional velocity.
			physObj:SetVelocity(self:GetVelocity() * REVIVAL.getSetting("deathForce", 5));
		end
	end
	
	function PLAYER:reviveBody()
		if(!self:Alive())then
			local oldAng = self:EyeAngles();
			self:Spawn();
				
			timer.Simple(0.15, function()
				if(self.deathPos && REVIVAL.getSetting("reviveAtDeath", true))then 
					self:SetPos(self.deathPos);
					self:SetAngles(oldAng);
				end
				
				if(!REVIVAL.getSetting("respawnBabygod", false))then
					if(IsValid(self) && self.Babygod)then 
						self.Babygod = nil;
						self:SetRenderMode(RENDERMODE_NORMAL);
						self:SetColor(Color(255, 255, 255, 255));
						self:GodDisable();
					end
				end
				
				self.deathPos = nil;
				
				if(REVIVAL.getSetting("showReviveMessage", true))then
					self:ConCommand("say "..REVIVAL.getSetting("reviveMessage", "I'm Alive!"));
				end
				
				hook.Call("Revival_onPlayerRevived", nil, self);
			end)
		end
	end
elseif(CLIENT)then

end