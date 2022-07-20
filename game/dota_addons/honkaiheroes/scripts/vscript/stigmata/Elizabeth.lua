LinkLuaModifier( "ElizabethT", "stigmata/Elizabeth", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "ElizabethM", "stigmata/Elizabeth", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "ElizabethB", "stigmata/Elizabeth", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "Elizabeth2Set", "stigmata/Elizabeth", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "Elizabeth3Set_cooldown", "stigmata/Elizabeth", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "Elizabeth3Set", "stigmata/Elizabeth", LUA_MODIFIER_MOTION_NONE )

item_ElizabethT = class({})
item_ElizabethM = class({})
item_ElizabethB = class({})

function item_ElizabethT:OnSpellStart()
	local caster = self:GetCaster()
	
	local mod = caster:AddNewModifier(caster, self, "ElizabethT", {})
	if caster.stigmata_t then
		caster.stigmata_t:Destroy()
	end
	caster.stigmata_t = mod
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "StigmaSwap", {setPos = 1, name = self:GetName(), hp = self:GetSpecialValueFor("hp_bonus"), atk = self:GetSpecialValueFor("atk_bonus") , def = self:GetSpecialValueFor("def_bonus") , crt = self:GetSpecialValueFor("crt_bonus")})
end

function item_ElizabethM:OnSpellStart()
	local caster = self:GetCaster()
	
	local mod = caster:AddNewModifier(caster, self, "ElizabethM", {})
	if caster.stigmata_m then
		caster.stigmata_m:Destroy()
	end
	caster.stigmata_m = mod
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "StigmaSwap", {setPos = 2, name = self:GetName(), hp = self:GetSpecialValueFor("hp_bonus"), atk = self:GetSpecialValueFor("atk_bonus") , def = self:GetSpecialValueFor("def_bonus") , crt = self:GetSpecialValueFor("crt_bonus")})
end

function item_ElizabethB:OnSpellStart()
	local caster = self:GetCaster()
	
	local mod = caster:AddNewModifier(caster, self, "ElizabethB", {})
	if caster.stigmata_b then
		caster.stigmata_b:Destroy()
	end
	caster.stigmata_b = mod
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "StigmaSwap", {setPos = 3, name = self:GetName(), hp = self:GetSpecialValueFor("hp_bonus"), atk = self:GetSpecialValueFor("atk_bonus") , def = self:GetSpecialValueFor("def_bonus") , crt = self:GetSpecialValueFor("crt_bonus")})
end

ElizabethT = class({})
ElizabethM = class({})
ElizabethB = class({})
Elizabeth2Set = class({})
Elizabeth3Set = class({})


--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--
function ElizabethT:IsHidden()return true end
function ElizabethT:RemoveOnDeath() return false end
function ElizabethT:IsPurgable()return false end

function ElizabethT:checkSet()
	local caster = self:GetCaster()
	res = 1
	if caster:HasModifier("ElizabethM") then
		res = res + 1
	end
	if caster:HasModifier("ElizabethB") then
		res = res + 1
	end
	return res
end

function ElizabethT:OnCreated()
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor_pct")
	self.bonus_physical_damage = self:GetAbility():GetSpecialValueFor("bonus_physical_damage")
	self.hp_bonus = self:GetAbility():GetSpecialValueFor("hp_bonus")
	self.atk_bonus = self:GetAbility():GetSpecialValueFor("atk_bonus")
	self.def_bonus = self:GetAbility():GetSpecialValueFor("def_bonus")
	self.crt_bonus = self:GetAbility():GetSpecialValueFor("crt_bonus")
	if not IsServer() then return end
	local set = self:checkSet()
	local caster = self:GetCaster()
	if set == 2 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Elizabeth2Set", {})
	end
	if set == 3 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Elizabeth3Set", {})
	end
	self.buff = self:GetCaster():TakeItem(self:GetAbility())
end

function ElizabethT:OnRefresh()
	self.bonus_physical_damage = self:GetAbility():GetSpecialValueFor("bonus_physical_damage")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor_pct")
	self:GetParent().stigmata_t = nil
end

function ElizabethT:OnRemoved()
	self:GetParent().stigmata_t = nil
	if not IsServer() then return end
	self:GetParent():AddItem(self.buff)
	local set = self:checkSet()
	if set == 2 then
		self:GetCaster():RemoveModifierByName("Elizabeth2Set")
	end
	if set == 3 then
		self:GetCaster():RemoveModifierByName("Elizabeth3Set")
	end
end

function ElizabethT:GetModifierBonusStat_CritRate()
	return self.bonus_physical_damage
end
function ElizabethT:GetModifierPhysicalArmorTotal_Percentage()
	if self:GetParent():GetHealthPercent() > 80 then
		return self.bonus_armor
	end
	return 0
end

function ElizabethT:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_TOTAL_PERCENTAGE 
	}
end

function ElizabethT:GetModifierHealthBonus()
	return self.hp_bonus
end

function ElizabethT:GetModifierPreAttack_BonusDamage()
	return self.atk_bonus
end

function ElizabethT:GetModifierPhysicalArmorBonus()
	return self.def_bonus
end
function ElizabethT:GetModifierStatCRT_Bonus()
	return self.crt_bonus
end

function ElizabethT:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_TOTAL_PERCENTAGE,
	}
end

--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--
function ElizabethM:IsHidden()return true end
function ElizabethM:RemoveOnDeath() return false end
function ElizabethM:IsPurgable()return false end

function ElizabethM:OnCreated()
	self.bonus_physical_damage = self:GetAbility():GetSpecialValueFor("bonus_physical_damage")
	self.bonus_physical_damage_ex = self:GetAbility():GetSpecialValueFor("bonus_physical_damage_ex")
	self.hp_bonus = self:GetAbility():GetSpecialValueFor("hp_bonus")
	self.atk_bonus = self:GetAbility():GetSpecialValueFor("atk_bonus")
	self.def_bonus = self:GetAbility():GetSpecialValueFor("def_bonus")
	self.crt_bonus = self:GetAbility():GetSpecialValueFor("crt_bonus")
	if not IsServer() then return end
	local set = self:checkSet()
	local caster = self:GetCaster()
	if set == 2 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Elizabeth2Set", {})
	end
	if set == 3 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Elizabeth3Set", {})
	end
	self.buff = caster:TakeItem(self:GetAbility())
end

function ElizabethM:OnRefresh()
	self.bonus_physical_damage = self:GetAbility():GetSpecialValueFor("bonus_physical_damage")
	self.bonus_physical_damage_ex = self:GetAbility():GetSpecialValueFor("bonus_physical_damage_ex")
	self:GetParent().stigmata_m = nil
end

function ElizabethM:OnRemoved()
	self:GetParent().stigmata_m = nil
	if not IsServer() then return end
	self:GetParent():AddItem(self.buff)
	local set = self:checkSet()
	if set == 2 then
		self:GetCaster():RemoveModifierByName("Elizabeth2Set")
	end
	if set == 3 then
		self:GetCaster():RemoveModifierByName("Elizabeth3Set")
	end
end

function ElizabethM:GetModifierBonusStats_PhysicalDamage()
	if self:GetParent():GetHealthPercent() > 80 then
		return self.bonus_physical_damage_ex+self.bonus_physical_damage
	end
	return self.bonus_physical_damage
end

function ElizabethM:checkSet()
	local caster = self:GetCaster()
	res = 1
	if caster:HasModifier("ElizabethT") then
		res = res + 1
	end
	if caster:HasModifier("ElizabethB") then
		res = res + 1
	end
	return res
end

function ElizabethM:GetModifierHealthBonus()
	return self.hp_bonus
end

function ElizabethM:GetModifierPreAttack_BonusDamage()
	return self.atk_bonus
end

function ElizabethM:GetModifierPhysicalArmorBonus()
	return self.def_bonus
end
function ElizabethM:GetModifierStatCRT_Bonus()
	return self.crt_bonus
end

function ElizabethM:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--
function ElizabethB:IsHidden()return true end
function ElizabethB:RemoveOnDeath() return false end
function ElizabethB:IsPurgable()return false end

function ElizabethB:OnCreated()
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor("bonus_move_speed")
	self.hp_bonus = self:GetAbility():GetSpecialValueFor("hp_bonus")
	self.atk_bonus = self:GetAbility():GetSpecialValueFor("atk_bonus")
	self.def_bonus = self:GetAbility():GetSpecialValueFor("def_bonus")
	self.crt_bonus = self:GetAbility():GetSpecialValueFor("crt_bonus")
	if not IsServer() then return end
	local set = self:checkSet()
	local caster = self:GetCaster()
	if set == 2 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Elizabeth2Set", {})
	end
	if set == 3 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Elizabeth3Set", {})
	end
	self.buff = self:GetCaster():TakeItem(self:GetAbility())
end

function ElizabethB:OnRefresh()
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor("bonus_move_speed")
	self:GetParent().stigmata_b = nil
end

function ElizabethB:OnRemoved()
	self:GetParent().stigmata_b = nil
	if not IsServer() then return end
	self:GetParent():AddItem(self.buff)
	local set = self:checkSet()
	if set == 2 then
		self:GetCaster():RemoveModifierByName("Elizabeth2Set")
	end
	if set == 3 then
		self:GetCaster():RemoveModifierByName("Elizabeth3Set")
	end
end


function ElizabethB:GetModifierMoveSpeedBonus_Percentage()
	if self:GetParent():GetHealthPercent() > 80 then
	return self.bonus_move_speed
	end
	return 0
end

function ElizabethB:checkSet()
	local caster = self:GetCaster()
	res = 1
	if caster:HasModifier("ElizabethM") then
		res = res + 1
	end
	if caster:HasModifier("ElizabethT") then
		res = res + 1
	end
	return res
end

function ElizabethB:GetModifierHealthBonus()
	return self.hp_bonus
end

function ElizabethB:GetModifierPreAttack_BonusDamage()
	return self.atk_bonus
end

function ElizabethB:GetModifierPhysicalArmorBonus()
	return self.def_bonus
end
function ElizabethB:GetModifierStatCRT_Bonus()
	return self.crt_bonus
end

function ElizabethB:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--
function Elizabeth2Set:IsHidden()return true end
function Elizabeth2Set:RemoveOnDeath() return false end
function Elizabeth2Set:IsPurgable()return false end

function Elizabeth2Set:OnCreated()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 2, dispatch = "Elizabeth2Set"}) end
end

function Elizabeth2Set:OnDestroy()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 2, name = "Elizabeth2Set"}) end
end

function Elizabeth2Set:GetModifierBonusStats_PhysicalDamage()
	return 20
end

function Elizabeth2Set:DeclareFunctions()
	return {
	MODIFIER_PROPERTY_EXTRA_MANA_PERCENTAGE,
	}
end

function Elizabeth2Set:GetModifierExtraManaPercentage(event)
	if self:GetParent():GetPrimaryAttribute() == DOTA_ATTRIBUTE_INTELLECT  then
	return 10
	end
	return 0
end

--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--
function Elizabeth3Set:IsHidden()return true end
function Elizabeth3Set:RemoveOnDeath() return false end
function Elizabeth3Set:IsPurgable()return false end

function Elizabeth3Set:OnCreated()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 3, dispatch = "Elizabeth3Set"}) end
end

function Elizabeth3Set:OnDestroy()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 3, name = "Elizabeth3Set"}) end
end

function Elizabeth3Set:GetModifierTotalDamageOutgoing_Percentage()
	if self:GetParent():GetAttackCapability() == DOTA_UNIT_CAP_MELEE_ATTACK then
		return 20
	end
	return 0
end

function Elizabeth3Set:OnAttackLanded(event)
	if event.attacker == self:GetParent() and not self:GetCaster():HasModifier("Elizabeth3Set_cooldown") and RollPercentage(10) then 
		event.attacker:Heal(event.attacker:GetMaxHealth()*0.03, self:GetAbility())
		self:GetCaster():AddNewModifier(self:GetCaster(), self.buff, "Elizabeth3Set_cooldown", {duration = 2})
	end
end

function Elizabeth3Set:GetModifierAttackSpeedPercentage()
	return 15
end

function Elizabeth3Set:DeclareFunctions()
	return {
	MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
	MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

Elizabeth3Set_cooldown = class({})

function Elizabeth3Set_cooldown:IsHidden()
	return true
end

