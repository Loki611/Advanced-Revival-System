SWEP.PrintName = "Defibrillator";
SWEP.Author = "Loki611";
SWEP.Purpose = "";
SWEP.Instructions = "Left click to revive a dead player. Reload to check recharge.";
SWEP.Contact = "";

SWEP.Slot = 3;
SWEP.SlotPos = 1;
SWEP.Weight = 2;
SWEP.AutoSwitchTo = true;
SWEP.AutoSwitchFrom = true;
SWEP.UseHands = true;

SWEP.Spawnable = true;
SWEP.AdminSpawnable = true;
SWEP.Category = "Revival System";

SWEP.ViewModel = Model("models/weapons/cstrike/c_c4.mdl")
SWEP.WorldModel = Model("models/weapons/w_c4.mdl")

SWEP.Primary.ClipSize		= -1;
SWEP.Primary.DefaultClip	= 1;
SWEP.Primary.Automatic		= false;
SWEP.Primary.Ammo			= "";
SWEP.Primary.Sound = "weapons/stunstick/spark1.wav";

SWEP.Secondary.ClipSize		= -1;
SWEP.Secondary.DefaultClip	= -1;
SWEP.Secondary.Automatic	= true;
SWEP.Secondary.Ammo			= "";

if(SERVER)then
	function SWEP:SendRechargeMessage()
		local curCharge = math.Round(self.nextCharge - CurTime());
		local chargeDelay = string.NiceTime(curCharge);
		local message = string.Replace(REVIVAL.getSetting("defibRechargeMessage", "Recharging.. {TIME} left"), "{TIME}", chargeDelay);
		local mesType = 1;
		
		if(curCharge <= 0)then
			message = REVIVAL.getSetting("defibChargedMessage", "Charge ready!");
			mesType = 0;
		end
		REVIVAL.notify(self.Owner, mesType, 4, message);
	end

	function SWEP:PrimaryAttack()
		self.nextCharge = self.nextCharge || CurTime();
		
		local rangeBonus = REVIVAL.getSetting("defibRange", 255);		
		self.Owner:LagCompensation(true);
		local traceRes = REVIVAL.getRangedTrace(self.Owner, rangeBonus);
		self.Owner:LagCompensation(false);
		
		if(!IsValid(traceRes.Entity))then return; end
		if(!traceRes.Entity:IsRagdoll() || !traceRes.Entity.isPlayerCorpse)then return; end
		
		local traceEnt = traceRes.Entity;
		local owner = traceEnt:GetOwner();
		
		if(owner && owner:IsValid())then
			if (self.nextCharge > CurTime())then
				self:SendRechargeMessage();
				return;
			end
			
			if(REVIVAL.getSetting("forceRevivalAccept", false))then
				REVIVAL.revivePlayer(owner, !REVIVAL.reviveAtDeath);
			else
				owner:requestRevive(self.Owner);
			end
		
			self.Owner:EmitSound(self.Primary.Sound);
			self.nextCharge = CurTime() + REVIVAL.getSetting("defibRecharge", 40);
		end
	end
	
	function SWEP:Reload()
		if((self.nextReload || CurTime()) <= CurTime())then
			self:SendRechargeMessage();
			self.nextReload = CurTime() + 4;
		end
	end
end

function SWEP:Initialize()
	util.PrecacheSound(self.Primary.Sound);
	self:SetHoldType("slam");
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + 1);
end