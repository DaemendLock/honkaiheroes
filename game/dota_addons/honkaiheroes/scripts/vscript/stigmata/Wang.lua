LinkLuaModifier( "WangT", "stigmata/Wang", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "WangM", "stigmata/Wang", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "WangMBuff", "stigmata/Wang", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "WangB", "stigmata/Wang", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "Wang2Set", "stigmata/Wang", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "Wang2Set_cooldown", "stigmata/Wang", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "Wang3Set", "stigmata/Wang", LUA_MODIFIER_MOTION_NONE )

item_WangT = class({})
item_WangM = class({})
item_WangB = class({})

function item_WangT:OnSpellStart()
	local caster = self:GetCaster()
	
	local mod = caster:AddNewModifier(caster, self, "WangT", {})
	if caster.stigmata_t then
		caster.stigmata_t:Destroy()
	end
	caster.stigmata_t = mod
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "StigmaSwap", {setPos = 1, name = self:GetName(), hp = self:GetSpecialValueFor("hp_bonus"), atk = self:GetSpecialValueFor("atk_bonus") , def = self:GetSpecialValueFor("def_bonus") , crt = self:GetSpecialValueFor("crt_bonus")})
end

function item_WangM:OnSpellStart()
	local caster = self:GetCaster()
	
	local mod = caster:AddNewModifier(caster, self, "WangM", {})
	if caster.stigmata_m then
		caster.stigmata_m:Destroy()
	end
	caster.stigmata_m = mod
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "StigmaSwap", {setPos = 2, name = self:GetName(), hp = self:GetSpecialValueFor("hp_bonus"), atk = self:GetSpecialValueFor("atk_bonus") , def = self:GetSpecialValueFor("def_bonus") , crt = self:GetSpecialValueFor("crt_bonus")})
end

function item_WangB:OnSpellStart()
	local caster = self:GetCaster()
	
	local mod = caster:AddNewModifier(caster, self, "WangB", {})
	if caster.stigmata_b then
		caster.stigmata_b:Destroy()
	end
	caster.stigmata_b = mod
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "StigmaSwap", {setPos = 3, name = self:GetName(), hp = self:GetSpecialValueFor("hp_bonus"), atk = self:GetSpecialValueFor("atk_bonus") , def = self:GetSpecialValueFor("def_bonus") , crt = self:GetSpecialValueFor("crt_bonus")})
end

WangT = class({})
WangM = class({})
WangB = class({})
Wang2Set = class({})
Wang3Set = class({})


--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--
function WangT:IsHidden()return true end
function WangT:RemoveOnDeath() return false end
function WangT:IsPurgable()return false end

function WangT:checkSet()
	local caster = self:GetCaster()
	res = 1
	if caster:HasModifier("WangM") then
		res = res + 1
	end
	if caster:HasModifier("WangB") then
		res = res + 1
	end
	return res
end

function WangT:OnCreated()
	self.bonus_fire_damage = self:GetAbility():GetSpecialValueFor("bonus_fire_damage")
	self.hp_bonus = self:GetAbility():GetSpecialValueFor("hp_bonus")
	self.atk_bonus = self:GetAbility():GetSpecialValueFor("atk_bonus")
	self.def_bonus = self:GetAbility():GetSpecialValueFor("def_bonus")
	self.crt_bonus = self:GetAbility():GetSpecialValueFor("crt_bonus")
	if not IsServer() then return end
	local set = self:checkSet()
	local caster = self:GetCaster()
	if set == 2 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Wang2Set", {})
	end
	if set == 3 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Wang3Set", {})
	end
	self.buff = self:GetCaster():TakeItem(self:GetAbility())
end

function WangT:OnRefresh()
	self.bonus_physical_damage = self:GetAbility():GetSpecialValueFor("bonus_fire_damage")
	self:GetParent().stigmata_t = nil
end

function WangT:OnRemoved()
	self:GetParent().stigmata_t = nil
	if not IsServer() then return end
	self:GetParent():AddItem(self.buff)
	local set = self:checkSet()
	if set == 2 then
		self:GetCaster():RemoveModifierByName("Wang2Set")
	end
	if set == 3 then
		self:GetCaster():RemoveModifierByName("Wang3Set")
	end
end

function WangT:GetModifierBonusStats_FireDamage()
	return self.bonus_fire_damage
end

function WangT:GetModifierHealthBonus()
	return self.hp_bonus
end

function WangT:GetModifierPreAttack_BonusDamage()
	return self.atk_bonus
end

function WangT:GetModifierPhysicalArmorBonus()
	return self.def_bonus
end
function WangT:GetModifierStatCRT_Bonus()
	return self.crt_bonus
end

function WangT:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--
function WangM:IsHidden()return true end
function WangM:RemoveOnDeath() return false end
function WangM:IsPurgable()return false end

function WangM:OnCreated()
	self.bonus_fire_damage = self:GetAbility():GetSpecialValueFor("bonus_fire_damage")
	self.bonus_total_damage = self:GetAbility():GetSpecialValueFor("bonus_total_damage")
	self.hp_bonus = self:GetAbility():GetSpecialValueFor("hp_bonus")
	self.atk_bonus = self:GetAbility():GetSpecialValueFor("atk_bonus")
	self.def_bonus = self:GetAbility():GetSpecialValueFor("def_bonus")
	self.crt_bonus = self:GetAbility():GetSpecialValueFor("crt_bonus")
	if not IsServer() then return end
	self:StartIntervalThink(10)
	local set = self:checkSet()
	local caster = self:GetCaster()
	if set == 2 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Wang2Set", {})
	end
	if set == 3 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Wang3Set", {})
	end
	self.buff = caster:TakeItem(self:GetAbility())
end

function WangM:OnRefresh()
	self.bonus_fire_damage = self:GetAbility():GetSpecialValueFor("bonus_fire_damage")
	self:GetParent().stigmata_m = nil
end

function WangM:OnIntervalThink()
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "WangMBuff", {duration = 5})
end

function WangM:OnRemoved()
	self:GetParent().stigmata_m = nil
	if not IsServer() then return end
	self:GetParent():AddItem(self.buff)
	local set = self:checkSet()
	if set == 2 then
		self:GetCaster():RemoveModifierByName("Wang2Set")
	end
	if set == 3 then
		self:GetCaster():RemoveModifierByName("Wang3Set")
	end
end

function WangM:GetModifierBonusStats_FireDamage()
	return self.bonus_fire_damage
end

function WangM:checkSet()
	local caster = self:GetCaster()
	res = 1
	if caster:HasModifier("WangT") then
		res = res + 1
	end
	if caster:HasModifier("WangB") then
		res = res + 1
	end
	return res
end


function WangM:GetModifierHealthBonus()
	return self.hp_bonus
end

function WangM:GetModifierPreAttack_BonusDamage()
	return self.atk_bonus
end

function WangM:GetModifierPhysicalArmorBonus()
	return self.def_bonus
end
function WangM:GetModifierStatCRT_Bonus()
	return self.crt_bonus
end

function WangM:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

WangMBuff = class({})

function WangMBuff:OnCreated()
		self.bonus_total_damage = self:GetAbility():GetSpecialValueFor("bonus_total_damage");
end

function WangMBuff:GetModifierTotalDamageOutgoing_Percentage()
	return self.bonus_total_damage
end

function WangMBuff:DeclareFunctions()
	return {
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
end

--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--
function WangB:IsHidden()return true end
function WangB:RemoveOnDeath() return false end
function WangB:IsPurgable()return false end

function WangB:OnCreated()
	self.bonus_total_damage = self:GetAbility():GetSpecialValueFor("bonus_total_damage")
	self.bonus_fire_damage = self:GetAbility():GetSpecialValueFor("bonus_fire_damage")
	self.hp_bonus = self:GetAbility():GetSpecialValueFor("hp_bonus")
	self.atk_bonus = self:GetAbility():GetSpecialValueFor("atk_bonus")
	self.def_bonus = self:GetAbility():GetSpecialValueFor("def_bonus")
	self.crt_bonus = self:GetAbility():GetSpecialValueFor("crt_bonus")
	if not IsServer() then return end
	local set = self:checkSet()
	local caster = self:GetCaster()
	if set == 2 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Wang2Set", {})
	end
	if set == 3 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Wang3Set", {})
	end
	self.buff = self:GetCaster():TakeItem(self:GetAbility())
end

function WangB:OnRefresh()
	self.bonus_total_damage = self:GetAbility():GetSpecialValueFor("bonus_total_damage")
	self.bonus_fire_damage = self:GetAbility():GetSpecialValueFor("bonus_fire_damage")
	self:GetParent().stigmata_b = nil
end

function WangB:OnRemoved()
	self:GetParent().stigmata_b = nil
	if not IsServer() then return end
	self:GetParent():AddItem(self.buff)
	local set = self:checkSet()
	if set == 2 then
		self:GetCaster():RemoveModifierByName("Wang2Set")
	end
	if set == 3 then
		self:GetCaster():RemoveModifierByName("Wang3Set")
	end
end

function WangB:GetModifierBonusStats_FireDamage()
	return self.bonus_fire_damage*(4)
end

function WangB:GetModifierTotalDamageOutgoing_Percentage()
	return self.bonus_total_damage
end

function WangB:checkSet()
	local caster = self:GetCaster()
	res = 1
	if caster:HasModifier("WangM") then
		res = res + 1
	end
	if caster:HasModifier("WangT") then
		res = res + 1
	end
	return res
end

function WangB:GetModifierHealthBonus()
	return self.hp_bonus
end

function WangB:GetModifierPreAttack_BonusDamage()
	return self.atk_bonus
end

function WangB:GetModifierPhysicalArmorBonus()
	return self.def_bonus
end
function WangB:GetModifierStatCRT_Bonus()
	return self.crt_bonus
end

function WangB:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
end
--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--
function Wang2Set:IsHidden()return true end
function Wang2Set:RemoveOnDeath() return false end
function Wang2Set:IsPurgable()return false end

function Wang2Set:OnCreated()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 2, dispatch = "Wang2Set"}) end
end

function Wang2Set:OnDestroy()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 2, name = "Wang2Set"}) end
end

function WangB:GetModifierBonusStats_FireDamage()
	return 15
end

function Wang3Set:OnAttackLanded(event)
	if event.attacker == self:GetParent() and not self:GetCaster():HasModifier("Wang2Set_cooldown") then 
		ApplyDamage({attacker = event.attacker, damage = event.attacker:GetAttackDamage()*3, ability = self:GetAbility(), damageType = DAMAGE_TYPE_MAGICAL, victim = event.target })
		self:GetCaster():AddNewModifier(self:GetCaster(), self.buff, "Wang2Set_cooldown", {duration = 15})
	end
end

function Wang2Set:DeclareFunctions()
	return {
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end


--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--
function Wang3Set:IsHidden()return true end
function Wang3Set:RemoveOnDeath() return false end
function Wang3Set:IsPurgable()return false end

function Wang3Set:OnCreated()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 3, dispatch = "Wang3Set"}) end
end

function Wang3Set:OnDestroy()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 3, name = "Wang3Set"}) end
end

function Wang3Set:GetModifierTotalDamageOutgoing_Percentage()
	if self:GetParent():GetAttackCapability() == DOTA_UNIT_CAP_MELEE_ATTACK then
		return 20
	end
	return 0
end

function Wang3Set:GetModifierTotalDamageOutgoing_Percentage()
	return 10
end

function Wang3Set:GetModifierExtraHealthPercentage()
	return 20
end

function Wang3Set:DeclareFunctions()
	return {
	MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
end




Wang2Set_cooldown = class({})

function Wang2Set_cooldown:IsHidden()
	return true
end

