LinkLuaModifier( "KiraT", "stigmata/Kira", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "KiraM", "stigmata/Kira", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "KiraB", "stigmata/Kira", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "KiraBBuff", "stigmata/Kira", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "Kira2Set", "stigmata/Kira", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "Kira3Set", "stigmata/Kira", LUA_MODIFIER_MOTION_NONE )

item_KiraT = class({})
item_KiraM = class({})
item_KiraB = class({})

function item_KiraT:OnSpellStart()
	local caster = self:GetCaster()
	
	local mod = caster:AddNewModifier(caster, self, "KiraT", {})
	if caster.stigmata_t then
		caster.stigmata_t:Destroy()
	end
	caster.stigmata_t = mod
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "StigmaSwap", {setPos = 1, name = self:GetName(), hp = self:GetSpecialValueFor("hp_bonus"), atk = self:GetSpecialValueFor("atk_bonus") , def = self:GetSpecialValueFor("def_bonus") , crt = self:GetSpecialValueFor("crt_bonus") })
end

function item_KiraM:OnSpellStart()
	local caster = self:GetCaster()
	
	local mod = caster:AddNewModifier(caster, self, "KiraM", {})
	if caster.stigmata_m then
		caster.stigmata_m:Destroy()
	end
	caster.stigmata_m = mod
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "StigmaSwap", {setPos = 2, name = self:GetName(), hp = self:GetSpecialValueFor("hp_bonus"), atk = self:GetSpecialValueFor("atk_bonus") , def = self:GetSpecialValueFor("def_bonus") , crt = self:GetSpecialValueFor("crt_bonus")})
end

function item_KiraB:OnSpellStart()
	local caster = self:GetCaster()
	
	local mod = caster:AddNewModifier(caster, self, "KiraB", {})
	if caster.stigmata_b then
		caster.stigmata_b:Destroy()
	end
	caster.stigmata_b = mod
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "StigmaSwap", {setPos = 3, name = self:GetName(), hp = self:GetSpecialValueFor("hp_bonus"), atk = self:GetSpecialValueFor("atk_bonus") , def = self:GetSpecialValueFor("def_bonus") , crt = self:GetSpecialValueFor("crt_bonus")})
end

KiraT = class({})
KiraM = class({})
KiraB = class({})
Kira2Set = class({})
Kira3Set = class({})


--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--
function KiraT:IsHidden()return true end
function KiraT:RemoveOnDeath() return false end
function KiraT:IsPurgable()return false end

function KiraT:checkSet()
	local caster = self:GetCaster()
	res = 1
	if caster:HasModifier("KiraM") then
		res = res + 1
	end
	if caster:HasModifier("KiraB") then
		res = res + 1
	end
	return res
end

function KiraT:OnCreated()
	self.elem_bonus = self:GetAbility():GetSpecialValueFor("elem_bonus")
	self.hp_bonus = self:GetAbility():GetSpecialValueFor("hp_bonus")
	self.atk_bonus = self:GetAbility():GetSpecialValueFor("atk_bonus")
	self.def_bonus = self:GetAbility():GetSpecialValueFor("def_bonus")
	self.crt_bonus = self:GetAbility():GetSpecialValueFor("crt_bonus")
	if not IsServer() then return end
	local set = self:checkSet()
	local caster = self:GetCaster()
	if set == 2 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Kira2Set", {})
	end
	if set == 3 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Kira3Set", {})
	end
	self.buff = self:GetCaster():TakeItem(self:GetAbility())
end

function KiraT:OnRefresh()
	self:GetParent().stigmata_t = nil
end

function KiraT:OnRemoved()
	self:GetParent().stigmata_t = nil
	if not IsServer() then return end
	self:GetParent():AddItem(self.buff)
	local set = self:checkSet()
	if set == 2 then
		self:GetCaster():RemoveModifierByName("Kira2Set")
	end
	if set == 3 then
		self:GetCaster():RemoveModifierByName("Kira3Set")
	end
end

function KiraT:GetModifierBonusStats_FireDamage()
	return self.elem_bonus
end

function KiraT:GetModifierBonusStats_IceDamage()
	return self.elem_bonus
end

function KiraT:GetModifierBonusStats_LightningDamage()
	return self.elem_bonus
end

function KiraT:GetModifierHealthBonus()
	return self.hp_bonus
end

function KiraT:GetModifierPreAttack_BonusDamage()
	return self.atk_bonus
end

function KiraT:GetModifierPhysicalArmorBonus()
	return self.def_bonus
end
function KiraT:GetModifierStatCRT_Bonus()
	return self.crt_bonus
end

function KiraT:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--

function KiraM:IsHidden()return true end
function KiraM:RemoveOnDeath() return false end
function KiraM:IsPurgable()return false end

function KiraM:OnCreated()
	self.health_bonus = self:GetAbility():GetSpecialValueFor("health_bonus")
	self.armot_bonus = self:GetAbility():GetSpecialValueFor("armot_bonus")
	self.hp_bonus = self:GetAbility():GetSpecialValueFor("hp_bonus")
	self.atk_bonus = self:GetAbility():GetSpecialValueFor("atk_bonus")
	self.def_bonus = self:GetAbility():GetSpecialValueFor("def_bonus")
	self.crt_bonus = self:GetAbility():GetSpecialValueFor("crt_bonus")
	if not IsServer() then return end
	local set = self:checkSet()
	local caster = self:GetCaster()
	if set == 2 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Kira2Set", {})
	end
	if set == 3 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Kira3Set", {})
	end
	self.buff = caster:TakeItem(self:GetAbility())
end

function KiraM:OnRefresh()
	self:GetParent().stigmata_m = nil
end

function KiraM:OnRemoved()
	self:GetParent().stigmata_m = nil
	if not IsServer() then return end
	self:GetParent():AddItem(self.buff)
	local set = self:checkSet()
	if set == 2 then
		self:GetCaster():RemoveModifierByName("Kira2Set")
	end
	if set == 3 then
		self:GetCaster():RemoveModifierByName("Kira3Set")
	end
end

function KiraM:checkSet()
	local caster = self:GetCaster()
	res = 1
	if caster:HasModifier("KiraT") then
		res = res + 1
	end
	if caster:HasModifier("KiraB") then
		res = res + 1
	end
	return res
end

function KiraM:GetModifierExtraHealthPercentage()
	return self.health_bonus
end

function KiraM:GetModifierPhysicalArmorTotal_Percentage()
	return self.armot_bonus
end

function KiraM:GetModifierHealthBonus()
	return self.hp_bonus;
end

function KiraM:GetModifierPreAttack_BonusDamage()
	return self.atk_bonus
end

function KiraM:GetModifierPhysicalArmorBonus()
	return self.def_bonus
end
function KiraM:GetModifierStatCRT_Bonus()
	return self.crt_bonus
end

function KiraM:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_TOTAL_PERCENTAGE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		
	}
end

--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--

function KiraB:IsHidden()return true end
function KiraB:RemoveOnDeath() return false end
function KiraB:IsPurgable()return false end

function KiraB:OnCreated()
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.hp_bonus = self:GetAbility():GetSpecialValueFor("hp_bonus")
	self.atk_bonus = self:GetAbility():GetSpecialValueFor("atk_bonus")
	self.def_bonus = self:GetAbility():GetSpecialValueFor("def_bonus")
	self.crt_bonus = self:GetAbility():GetSpecialValueFor("crt_bonus")
	if not IsServer() then return end
	local set = self:checkSet()
	local caster = self:GetCaster()
	if set == 2 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Kira2Set", {})
	end
	if set == 3 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Kira3Set", {})
	end
	self.buff = self:GetCaster():TakeItem(self:GetAbility())
end

function KiraB:OnRefresh()
	self.special_var = self:GetAbility():GetSpecialValueFor("special_var")
	self:GetParent().stigmata_b = nil
end

function KiraB:OnRemoved()
	self:GetParent().stigmata_b = nil
	if not IsServer() then return end
	self:GetParent():AddItem(self.buff)
	local set = self:checkSet()
	if set == 2 then
		self:GetCaster():RemoveModifierByName("Kira2Set")
	end
	if set == 3 then
		self:GetCaster():RemoveModifierByName("Kira3Set")
	end
end

function KiraB:checkSet()
	local caster = self:GetCaster()
	res = 1
	if caster:HasModifier("KiraM") then
		res = res + 1
	end
	if caster:HasModifier("KiraT") then
		res = res + 1
	end
	return res
end

function KiraB:OnProjectileDodge(event)
	if event.target ~= self:GetParent() then return end
	event.target:AddNewModifier(event.target, self:GetAbility(), "KiraBBuff", {duration = self.duration})
end

function KiraB:GetModifierHealthBonus()
	return self.hp_bonus;
end

function KiraB:GetModifierPreAttack_BonusDamage()
	return self.atk_bonus
end

function KiraB:GetModifierPhysicalArmorBonus()
	return self.def_bonus
end
function KiraB:GetModifierStatCRT_Bonus()
	return self.crt_bonus
end

function KiraB:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_PROJECTILE_DODGE 
	}
end

KiraBBuff = class({})

function KiraBBuff:OnCreated()
	self.elem_bonus = self:GetAbility():GetSpecialValueFor("elem_bonus")
end

function KiraBBuff:GetModifierBonusStats_FireDamage()
	return self.elem_bonus
end

function KiraBBuff:GetModifierBonusStats_IceDamage()
	return self.elem_bonus
end

function KiraBBuff:GetModifierBonusStats_LightningDamage()
	return self.elem_bonus
end

function KiraBBuff:DeclareFunctions()
	return {}
end

--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--
function Kira2Set:IsHidden()return true end
function Kira2Set:RemoveOnDeath() return false end
function Kira2Set:IsPurgable()return false end

function Kira2Set:OnCreated()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 2, dispatch = "Kira2Set"}) end
end

function Kira2Set:OnDestroy()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 2, name = "Kira2Set"}) end
end

function Kira2Set:GetModifierBreach_PhysicalDamage()
	return -15
end

function Kira2Set:DeclareFunctions()
	return {}
end

--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--
function Kira3Set:IsHidden()return true end
function Kira3Set:RemoveOnDeath() return false end
function Kira3Set:IsPurgable()return false end

function Kira3Set:OnCreated()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 3, dispatch = "Kira3Set"}) end
end

function Kira3Set:OnDestroy()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 3, name = "Kira3Set"}) end
end

function Kira3Set:GetModifierTotalDamageOutgoing_Percentage()
	return 15
end

function Kira3Set:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE 
	}
end
