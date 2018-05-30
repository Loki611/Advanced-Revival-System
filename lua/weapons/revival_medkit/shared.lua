SWEP.PrintName = "MedKit";
SWEP.Author = "Loki611";
SWEP.Purpose = "";
SWEP.Instructions = "Left click to heal a player. Right click to heal yourself.";
SWEP.Contact = "";

SWEP.Slot = 3;
SWEP.SlotPos = 2;
SWEP.Weight = 2;
SWEP.AutoSwitchTo = true;
SWEP.AutoSwitchFrom = true;
SWEP.UseHands = true;

SWEP.Spawnable = true;
SWEP.AdminSpawnable = true;
SWEP.Category = "Revival System";

SWEP.ViewModel = Model("models/weapons/c_medkit.mdl");
SWEP.WorldModel = Model("models/weapons/w_medkit.mdl");
SWEP.UseHands = true;

SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = 1;
SWEP.Primary.Automatic = true;
SWEP.Primary.Ammo = "none";

SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = 1;
SWEP.Secondary.Automatic = true;
SWEP.Secondary.Ammo = "none";

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + REVIVAL.getSetting("medkitRate", 0.1));

	local owner = self:GetOwner();
	local found = nil;
	local lastDot = -1;
	owner:LagCompensation(true);
	local aimVec = self:GetOwner():GetAimVector();

	local pls = player.GetAll();
	for i=1, #pls do
		local v = pls[i];
		local maxHealth = v:GetMaxHealth() || 100;
		if(v == owner || !v:Alive())then continue; end
		if(v:GetShootPos():Distance(owner:GetShootPos()) > REVIVAL.getSetting("medkitRange", 100) || v:Health() >= maxHealth)then continue; end
		
		local direction = v:GetShootPos() - owner:GetShootPos();
		direction:Normalize();
		local dot = direction:Dot(aimVec);

		if(dot > lastDot)then
			lastDot = dot;
			found = v;
		end
	end
	owner:LagCompensation(false);

	if(found)then
		found:SetHealth(found:Health() + REVIVAL.getSetting("medkitHealth", 1));
		self:EmitSound("hl1/fvox/boop.wav", 150, (found:Health() / found:GetMaxHealth()) * 100, 1, CHAN_AUTO);
	end
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + REVIVAL.getSetting("medkitRate", 0.1));
	local pl = self:GetOwner();
	local maxHealth = self:GetOwner():GetMaxHealth() || 100;
	
	if(pl:Health() < maxHealth)then
		pl:SetHealth(pl:Health() + 1);
		self:EmitSound("hl1/fvox/boop.wav", 150, pl:Health() / pl:GetMaxHealth() * 100, 1, CHAN_AUTO);
	end
end