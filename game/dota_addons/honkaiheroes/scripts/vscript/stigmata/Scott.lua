LinkLuaModifier( "ScottT", "stigmata/Scott", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "ScottM", "stigmata/Scott", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "ScottB", "stigmata/Scott", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "Scott2Set", "stigmata/Scott", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "Scott3Set", "stigmata/Scott", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "ScottB_cooldown", "stigmata/Scott", LUA_MODIFIER_MOTION_NONE )

item_ScottT = class({})
item_ScottM = class({})
item_ScottB = class({})

function item_ScottT:OnSpellStart()
	local caster = self:GetCaster()
	local mod = caster:AddNewModifier(caster, self, "ScottT", {})
	if caster.stigmata_t then
		caster.stigmata_t:Destroy()
	end
	caster.stigmata_t = mod
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "StigmaSwap", {setPos = 1, name = self:GetName(), hp = self:GetSpecialValueFor("hp_bonus"), atk = self:GetSpecialValueFor("atk_bonus") , def = self:GetSpecialValueFor("def_bonus") , crt = self:GetSpecialValueFor("crt_bonus")})
end

function item_ScottM:OnSpellStart()
	local caster = self:GetCaster()
	
	local mod = caster:AddNewModifier(caster, self, "ScottM", {})
	if caster.stigmata_m then
		caster.stigmata_m:Destroy()
	end
	caster.stigmata_m = mod
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "StigmaSwap", {setPos = 2, name = self:GetName(), hp = self:GetSpecialValueFor("hp_bonus"), atk = self:GetSpecialValueFor("atk_bonus") , def = self:GetSpecialValueFor("def_bonus") , crt = self:GetSpecialValueFor("crt_bonus")})
end

function item_ScottB:OnSpellStart()
	local caster = self:GetCaster()
	
	local mod = caster:AddNewModifier(caster, self, "ScottB", {})
	if caster.stigmata_b then
		caster.stigmata_b:Destroy()
	end
	caster.stigmata_b = mod
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "StigmaSwap", {setPos = 3, name = self:GetName(), hp = self:GetSpecialValueFor("hp_bonus"), atk = self:GetSpecialValueFor("atk_bonus") , def = self:GetSpecialValueFor("def_bonus") , crt = self:GetSpecialValueFor("crt_bonus")})
end

ScottT = class({})
ScottM = class({})
ScottB = class({})
Scott2Set = class({})
Scott3Set = class({})


--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--
function ScottT:IsHidden()return true end
function ScottT:RemoveOnDeath() return false end
function ScottT:IsPurgable()return false end

function ScottT:checkSet()
	local caster = self:GetCaster()
	res = 1
	if caster:HasModifier("ScottM") then
		res = res + 1
	end
	if caster:HasModifier("ScottB") then
		res = res + 1
	end
	return res
end

function ScottT:OnCreated()
	self.bonus_ice_damage = self:GetAbility():GetSpecialValueFor("bonus_ice_damage")
	self.bonus_total_damage = self:GetAbility():GetSpecialValueFor("bonus_total_damage")
	self.max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")
	self.hp_bonus = self:GetAbility():GetSpecialValueFor("hp_bonus")
	self.atk_bonus = self:GetAbility():GetSpecialValueFor("atk_bonus")
	self.def_bonus = self:GetAbility():GetSpecialValueFor("def_bonus")
	self.crt_bonus = self:GetAbility():GetSpecialValueFor("crt_bonus")
	if not IsServer() then return end
	local set = self:checkSet()
	local caster = self:GetCaster()
	if set == 2 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Scott2Set", {})
	end
	if set == 3 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Scott3Set", {})
	end
	self.buff = self:GetCaster():TakeItem(self:GetAbility())
end

function ScottT:OnRefresh()
	self.bonus_ice_damage = self:GetAbility():GetSpecialValueFor("bonus_ice_damage")
	self.bonus_total_damage = self:GetAbility():GetSpecialValueFor("bonus_total_damage")
	self.max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")
	self:GetParent().stigmata_t = nil
end

function ScottT:OnRemoved()
	self:GetParent().stigmata_t = nil
	if not IsServer() then return end
	self:GetParent():AddItem(self.buff)
	local set = self:checkSet()
	if set == 2 then
		self:GetCaster():RemoveModifierByName("Scott2Set")
	end
	if set == 3 then
		self:GetCaster():RemoveModifierByName("Scott3Set")
	end
end

function ScottT:GetModifierBonusStats_IceDamage()
	return self.bonus_ice_damage
end

function ScottT:GetModifierTotalDamageOutgoing_Percentage()
	return min(self:GetParent().combo_hit:GetStackCount(), self.max_stacks)*self.bonus_total_damage
end

function ScottT:GetModifierHealthBonus()
	return self.hp_bonus;
end

function ScottT:GetModifierPreAttack_BonusDamage()
	return self.atk_bonus
end

function ScottT:GetModifierPhysicalArmorBonus()
	return self.def_bonus
end
function ScottT:GetModifierStatCRT_Bonus()
	return self.crt_bonus
end

function ScottT:DeclareFunctions()
	return{
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end




--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--

function ScottM:IsHidden()return true end
function ScottM:RemoveOnDeath() return false end
function ScottM:IsPurgable()return false end

function ScottM:OnCreated()
	self.bonus_ice_damage = self:GetAbility():GetSpecialValueFor("bonus_ice_damage")
	self.bonus_charged_damage = self:GetAbility():GetSpecialValueFor("bonus_charged_damage")
	self.hp_bonus = self:GetAbility():GetSpecialValueFor("hp_bonus")
	self.atk_bonus = self:GetAbility():GetSpecialValueFor("atk_bonus")
	self.def_bonus = self:GetAbility():GetSpecialValueFor("def_bonus")
	self.crt_bonus = self:GetAbility():GetSpecialValueFor("crt_bonus")
	if not IsServer() then return end
	local set = self:checkSet()
	local caster = self:GetCaster()
	if set == 2 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Scott2Set", {})
	end
	if set == 3 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Scott3Set", {})
	end
	self.buff = caster:TakeItem(self:GetAbility())
end

function ScottM:OnRefresh()
	self.bonus_ice_damage = self:GetAbility():GetSpecialValueFor("bonus_ice_damage")
	self.bonus_charged_damage = self:GetAbility():GetSpecialValueFor("bonus_charged_damage")
	self:GetParent().stigmata_m = nil
end

function ScottM:OnRemoved()
	self:GetParent().stigmata_m = nil
	if not IsServer() then return end
	self:GetParent():AddItem(self.buff)
	local set = self:checkSet()
	if set == 2 then
		self:GetCaster():RemoveModifierByName("Scott2Set")
	end
	if set == 3 then
		self:GetCaster():RemoveModifierByName("Scott3Set")
	end
end

function ScottM:GetModifierBonusStats_ChargedDamage()
	return self.bonus_charged_damage
end

function ScottM:GetModifierBonusStats_SpecialDamage()
	return self.bonus_charged_damage
end

function ScottM:GetModifierBonusStats_IceDamage()
	return self.bonus_ice_damage
end

function ScottM:checkSet()
	local caster = self:GetCaster()
	res = 1
	if caster:HasModifier("ScottT") then
		res = res + 1
	end
	if caster:HasModifier("ScottB") then
		res = res + 1
	end
	return res
end

function ScottM:GetModifierHealthBonus()
	return self.hp_bonus;
end

function ScottM:GetModifierPreAttack_BonusDamage()
	return self.atk_bonus
end

function ScottM:GetModifierPhysicalArmorBonus()
	return self.def_bonus
end
function ScottM:GetModifierStatCRT_Bonus()
	return self.crt_bonus
end

function ScottM:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--

function ScottB:IsHidden()return true end
function ScottB:RemoveOnDeath() return false end
function ScottB:IsPurgable()return false end

function ScottB:OnCreated()
	self.extra_health = self:GetAbility():GetSpecialValueFor("extra_health")
	self.hp_bonus = self:GetAbility():GetSpecialValueFor("hp_bonus")
	self.atk_bonus = self:GetAbility():GetSpecialValueFor("atk_bonus")
	self.def_bonus = self:GetAbility():GetSpecialValueFor("def_bonus")
	self.crt_bonus = self:GetAbility():GetSpecialValueFor("crt_bonus")
	if not IsServer() then return end
	local set = self:checkSet()
	local caster = self:GetCaster()
	if set == 2 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Scott2Set", {})
	end
	if set == 3 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Scott3Set", {})
	end
	self.buff = self:GetCaster():TakeItem(self:GetAbility())
end

function ScottB:OnRefresh()
	self.extra_health = self:GetAbility():GetSpecialValueFor("extra_health")
	self:GetParent().stigmata_b = nil
end

function ScottB:OnRemoved()
	self:GetParent().stigmata_b = nil
	if not IsServer() then return end
	self:GetParent():AddItem(self.buff)
	local set = self:checkSet()
	if set == 2 then
		self:GetCaster():RemoveModifierByName("Scott2Set")
	end
	if set == 3 then
		self:GetCaster():RemoveModifierByName("Scott3Set")
	end
end

function ScottB:DestroyOnExpire() return false end

function ScottB:OnAttackLanded(event)
	if event.attacker == self:GetParent() and not self:GetCaster():HasModifier("ScottB_cooldown") and RollPercentage(20) then 
		event.attacker:Heal(200, self.buff)
		self:GetCaster():AddNewModifier(self:GetCaster(), self.buff, "ScottB_cooldown", {duration = 10})
	end
end

function ScottB:GetModifierExtraHealthPercentage()
	return self.extra_health
end

function ScottB:checkSet()
	local caster = self:GetCaster()
	res = 1
	if caster:HasModifier("ScottM") then
		res = res + 1
	end
	if caster:HasModifier("ScottT") then
		res = res + 1
	end
	return res
end

function ScottB:GetModifierHealthBonus()
	return self.hp_bonus;
end

function ScottB:GetModifierPreAttack_BonusDamage()
	return self.atk_bonus
end

function ScottB:GetModifierPhysicalArmorBonus()
	return self.def_bonus
end
function ScottB:GetModifierStatCRT_Bonus()
	return self.crt_bonus
end

function ScottB:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

ScottB_cooldown = class({})

function ScottB_cooldown:IsHidden()
	return true
end

--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--
function Scott2Set:IsHidden()return true end
function Scott2Set:RemoveOnDeath() return false end
function Scott2Set:IsPurgable()return false end

function Scott2Set:OnCreated()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 2, dispatch = "Scott2Set"}) end
end

function Scott2Set:OnDestroy()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 2, name = "Scott2Set"}) end
end

function Scott2Set:DeclareFunctions()
	return {
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
end

function Scott2Set:GetModifierBonusStats_TotalDamage()
	return 12
end

--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--
function Scott3Set:IsHidden()return true end
function Scott3Set:RemoveOnDeath() return false end
function Scott3Set:IsPurgable()return false end

function Scott3Set:OnCreated()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 3, dispatch = "Scott3Set"}) end
end

function Scott3Set:OnDestroy()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 3, name = "Scott3Set"}) end
end

function ScottB:DestroyOnExpire() return false end

function Scott3Set:GetModifierBonusStats_ChargedDamage()
	if self:GetRemainingTime() > 0 then
		return 18
	end
	return 0
end

function Scott3Set:GetModifierBonusStats_SpecialDamage()
	if self:GetRemainingTime() > 0 then
		return 18
	end
	return 0
end	
