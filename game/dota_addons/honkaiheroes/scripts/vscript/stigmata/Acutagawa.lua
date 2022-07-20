LinkLuaModifier( "AcutagawaT", "stigmata/Acutagawa", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "AcutagawaM", "stigmata/Acutagawa", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "AcutagawaB", "stigmata/Acutagawa", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "Acutagawa2Set", "stigmata/Acutagawa", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "Acutagawa2Set_cooldown", "stigmata/Acutagawa", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "Acutagawa3Set", "stigmata/Acutagawa", LUA_MODIFIER_MOTION_NONE )

item_AcutagawaT = class({})
item_AcutagawaM = class({})
item_AcutagawaB = class({})

function item_AcutagawaT:OnSpellStart()
	local caster = self:GetCaster()
	
	local mod = caster:AddNewModifier(caster, self, "AcutagawaT", {})
	if caster.stigmata_t then
		caster.stigmata_t:Destroy()
	end
	caster.stigmata_t = mod
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "StigmaSwap", {setPos = 1, name = self:GetName(), hp = self:GetSpecialValueFor("hp_bonus"), atk = self:GetSpecialValueFor("atk_bonus") , def = self:GetSpecialValueFor("def_bonus") , crt = self:GetSpecialValueFor("crt_bonus")})
end

function item_AcutagawaM:OnSpellStart()
	local caster = self:GetCaster()
	
	local mod = caster:AddNewModifier(caster, self, "AcutagawaM", {})
	if caster.stigmata_m then
		caster.stigmata_m:Destroy()
	end
	caster.stigmata_m = mod
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "StigmaSwap", {setPos = 2, name = self:GetName(), hp = self:GetSpecialValueFor("hp_bonus"), atk = self:GetSpecialValueFor("atk_bonus") , def = self:GetSpecialValueFor("def_bonus") , crt = self:GetSpecialValueFor("crt_bonus")})
end

function item_AcutagawaB:OnSpellStart()
	local caster = self:GetCaster()
	
	local mod = caster:AddNewModifier(caster, self, "AcutagawaB", {})
	if caster.stigmata_b then
		caster.stigmata_b:Destroy()
	end
	caster.stigmata_b = mod
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "StigmaSwap", {setPos = 3, name = self:GetName(), hp = self:GetSpecialValueFor("hp_bonus"), atk = self:GetSpecialValueFor("atk_bonus") , def = self:GetSpecialValueFor("def_bonus") , crt = self:GetSpecialValueFor("crt_bonus")})
end

AcutagawaT = class({})
AcutagawaM = class({})
AcutagawaB = class({})
Acutagawa2Set = class({})
Acutagawa3Set = class({})


--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--
function AcutagawaT:IsHidden()return true end
function AcutagawaT:RemoveOnDeath() return false end
function AcutagawaT:IsPurgable()return false end

function AcutagawaT:checkSet()
	local caster = self:GetCaster()
	res = 1
	if caster:HasModifier("AcutagawaM") then
		res = res + 1
	end
	if caster:HasModifier("AcutagawaB") then
		res = res + 1
	end
	return res
end

function AcutagawaT:OnCreated()
	self.bonus_physical_damage = self:GetAbility():GetSpecialValueFor("bonus_physical_damage")
	self.hp_bonus = self:GetAbility():GetSpecialValueFor("hp_bonus")
	self.atk_bonus = self:GetAbility():GetSpecialValueFor("atk_bonus")
	self.def_bonus = self:GetAbility():GetSpecialValueFor("def_bonus")
	self.crt_bonus = self:GetAbility():GetSpecialValueFor("crt_bonus")
	if not IsServer() then return end
	local set = self:checkSet()
	local caster = self:GetCaster()
	if set == 2 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Acutagawa2Set", {})
	end
	if set == 3 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Acutagawa3Set", {})
	end
	self.buff = self:GetCaster():TakeItem(self:GetAbility())
end

function AcutagawaT:OnRefresh()
	self.bonus_physical_damage = self:GetAbility():GetSpecialValueFor("bonus_physical_damage")
	self:GetParent().stigmata_t = nil
end

function AcutagawaT:OnRemoved()
	self:GetParent().stigmata_t = nil
	if not IsServer() then return end
	self:GetParent():AddItem(self.buff)
	local set = self:checkSet()
	if set == 2 then
		self:GetCaster():RemoveModifierByName("Acutagawa2Set")
	end
	if set == 3 then
		self:GetCaster():RemoveModifierByName("Acutagawa3Set")
	end
end

function AcutagawaT:GetModifierBonusStats_PhysicalDamage()
	if self:GetParent():GetAttackCapability() == DOTA_UNIT_CAP_MELEE_ATTACK then
		return self.bonus_physical_damage
	end
	return 0 
end

function AcutagawaT:GetModifierHealthBonus()
	return self.hp_bonus;
end

function AcutagawaT:GetModifierPreAttack_BonusDamage()
	return self.atk_bonus
end

function AcutagawaT:GetModifierPhysicalArmorBonus()
	return self.def_bonus
end
function AcutagawaT:GetModifierStatCRT_Bonus()
	return self.crt_bonus
end

function AcutagawaT:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--
function AcutagawaM:IsHidden()return true end
function AcutagawaM:RemoveOnDeath() return false end
function AcutagawaM:IsPurgable()return false end

function AcutagawaM:OnCreated()
	self.bonus_crit_rate = self:GetAbility():GetSpecialValueFor("bonus_crit_rate")
	self.hp_bonus = self:GetAbility():GetSpecialValueFor("hp_bonus")
	self.atk_bonus = self:GetAbility():GetSpecialValueFor("atk_bonus")
	self.def_bonus = self:GetAbility():GetSpecialValueFor("def_bonus")
	self.crt_bonus = self:GetAbility():GetSpecialValueFor("crt_bonus")
	if not IsServer() then return end
	local set = self:checkSet()
	local caster = self:GetCaster()
	if set == 2 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Acutagawa2Set", {})
	end
	if set == 3 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Acutagawa3Set", {})
	end
	self.buff = caster:TakeItem(self:GetAbility())
end

function AcutagawaM:OnRefresh()
	self.bonus_ice_damage = self:GetAbility():GetSpecialValueFor("bonus_ice_damage")
	self:GetParent().stigmata_m = nil
end

function AcutagawaM:OnRemoved()
	self:GetParent().stigmata_m = nil
	if not IsServer() then return end
	self:GetParent():AddItem(self.buff)
	local set = self:checkSet()
	if set == 2 then
		self:GetCaster():RemoveModifierByName("Acutagawa2Set")
	end
	if set == 3 then
		self:GetCaster():RemoveModifierByName("Acutagawa3Set")
	end
end

function AcutagawaM:GetModifierBonusStat_CritRate()
	return self.bonus_crit_rate*min(5, self:GetParent().combo_hit:GetStackCount())
end

function AcutagawaM:checkSet()
	local caster = self:GetCaster()
	res = 1
	if caster:HasModifier("AcutagawaT") then
		res = res + 1
	end
	if caster:HasModifier("AcutagawaB") then
		res = res + 1
	end
	return res
end

function AcutagawaM:GetModifierHealthBonus()
	return self.hp_bonus;
end

function AcutagawaM:GetModifierPreAttack_BonusDamage()
	return self.atk_bonus
end

function AcutagawaM:GetModifierPhysicalArmorBonus()
	return self.def_bonus
end
function AcutagawaM:GetModifierStatCRT_Bonus()
	return self.crt_bonus
end

function AcutagawaM:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--
function AcutagawaB:IsHidden()return true end
function AcutagawaB:RemoveOnDeath() return false end
function AcutagawaB:IsPurgable()return false end

function AcutagawaB:OnCreated()
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.hp_bonus = self:GetAbility():GetSpecialValueFor("hp_bonus")
	self.atk_bonus = self:GetAbility():GetSpecialValueFor("atk_bonus")
	self.def_bonus = self:GetAbility():GetSpecialValueFor("def_bonus")
	self.crt_bonus = self:GetAbility():GetSpecialValueFor("crt_bonus")
	if not IsServer() then return end
	local set = self:checkSet()
	local caster = self:GetCaster()
	if set == 2 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Acutagawa2Set", {})
	end
	if set == 3 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Acutagawa3Set", {})
	end
	self.buff = self:GetCaster():TakeItem(self:GetAbility())
end

function AcutagawaB:OnRefresh()
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self:GetParent().stigmata_b = nil
end

function AcutagawaB:OnRemoved()
	self:GetParent().stigmata_b = nil
	if not IsServer() then return end
	self:GetParent():AddItem(self.buff)
	local set = self:checkSet()
	if set == 2 then
		self:GetCaster():RemoveModifierByName("Acutagawa2Set")
	end
	if set == 3 then
		self:GetCaster():RemoveModifierByName("Acutagawa3Set")
	end
end

function AcutagawaB:OnAttackLanded(event)
	if event.attacker == self:GetParent() and self:GetRemainingTime() <= 0 and RollPercentage(20) then 
		event.attacker:Heal(200, self.buff)
		self:SetDuration(10, true)
	end
end

function AcutagawaB:GetModifierAttackSpeedPercentage()
	return self.bonus_attack_speed*min(self:GetParent().combo_hit:GetStackCount(), 5)
end

function AcutagawaB:checkSet()
	local caster = self:GetCaster()
	res = 1
	if caster:HasModifier("AcutagawaM") then
		res = res + 1
	end
	if caster:HasModifier("AcutagawaT") then
		res = res + 1
	end
	return res
end

function AcutagawaB:GetModifierHealthBonus()
	return self.hp_bonus;
end

function AcutagawaB:GetModifierPreAttack_BonusDamage()
	return self.atk_bonus
end

function AcutagawaB:GetModifierPhysicalArmorBonus()
	return self.def_bonus
end
function AcutagawaB:GetModifierStatCRT_Bonus()
	return self.crt_bonus
end

function AcutagawaB:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE ,
	}
end
--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--
function Acutagawa2Set:IsHidden()return true end
function Acutagawa2Set:RemoveOnDeath() return false end
function Acutagawa2Set:IsPurgable()return false end

function Acutagawa2Set:OnCreated()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 2, dispatch = "Acutagawa2Set"}) end
	self:SetStackCount(min(self:GetCaster():GetMaxHealth()*0.15, 1800))
end

function Acutagawa2Set:OnDestroy()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 2, name = "Acutagawa2Set"}) end
end

function Acutagawa2Set:DeclareFunctions()
	return {
	MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT,
	MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT,
	}
end

function Acutagawa2Set:GetModifierIncomingSpellDamageConstant(event)
	if event.target == self:GetCaster() then
		local red = self:GetStackCount()
		if event.damage > red then
			self:SetStackCount(0)
			return -red
		end
		self:SetStackCount(self:GetStackCount()-event.damage)
		return -event.damage
	end
end

function Acutagawa2Set:GetModifierIncomingPhysicalDamageConstant(event)
	if event.target == self:GetCaster() then
		local red = self:GetStackCount()
		if event.damage > red then
			self:SetStackCount(0)
			return -red
		end
		self:SetStackCount(self:GetStackCount()-event.damage)
		return -event.damage
	end
end

function Acutagawa2Set:GetModifierBonusStat_CritDamage()
	if self:GetCaster():HasModifier("Acutagawa2Set_cooldown") then return 0 end
	return 40
end

function Acutagawa2Set:GetModifierBonusStats_TotalDamage()
	return 12
end

Acutagawa2Set_cooldown = class({})

function Acutagawa2Set_cooldown:IsHidden()
	return true
end

--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--
function Acutagawa3Set:IsHidden()return true end
function Acutagawa3Set:RemoveOnDeath() return false end
function Acutagawa3Set:IsPurgable()return false end

function Acutagawa3Set:OnCreated()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 3, dispatch = "Acutagawa3Set"}) end
end

function Acutagawa3Set:OnDestroy()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 3, name = "Acutagawa3Set"}) end
end

function Acutagawa3Set:GetModifierTotalDamageOutgoing_Percentage()
	if self:GetParent():GetAttackCapability() == DOTA_UNIT_CAP_MELEE_ATTACK then
		return 20
	end
	return 0
end

function Acutagawa3Set:DeclareFunctions()
	return {
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
end

