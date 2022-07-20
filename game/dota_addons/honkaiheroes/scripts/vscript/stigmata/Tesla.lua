LinkLuaModifier( "TeslaT", "stigmata/Tesla", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "TeslaM", "stigmata/Tesla", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "TeslaB", "stigmata/Tesla", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "Tesla2Set", "stigmata/Tesla", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "Tesla3Set", "stigmata/Tesla", LUA_MODIFIER_MOTION_NONE )

item_TeslaT = class({})
item_TeslaM = class({})
item_TeslaB = class({})

function item_TeslaT:OnSpellStart()
	local caster = self:GetCaster()
	
	local mod = caster:AddNewModifier(caster, self, "TeslaT", {})
	if caster.stigmata_t then
		caster.stigmata_t:Destroy()
	end
	caster.stigmata_t = mod
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "StigmaSwap", {setPos = 1, name = self:GetName(), hp = self:GetSpecialValueFor("hp_bonus"), atk = self:GetSpecialValueFor("atk_bonus") , def = self:GetSpecialValueFor("def_bonus") , crt = self:GetSpecialValueFor("crt_bonus")})
end

function item_TeslaM:OnSpellStart()
	local caster = self:GetCaster()
	
	local mod = caster:AddNewModifier(caster, self, "TeslaM", {})
	if caster.stigmata_m then
		caster.stigmata_m:Destroy()
	end
	caster.stigmata_m = mod
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "StigmaSwap", {setPos = 2, name = self:GetName(), hp = self:GetSpecialValueFor("hp_bonus"), atk = self:GetSpecialValueFor("atk_bonus") , def = self:GetSpecialValueFor("def_bonus") , crt = self:GetSpecialValueFor("crt_bonus")})
end

function item_TeslaB:OnSpellStart()
	local caster = self:GetCaster()
	
	local mod = caster:AddNewModifier(caster, self, "TeslaB", {})
	if caster.stigmata_b then
		caster.stigmata_b:Destroy()
	end
	caster.stigmata_b = mod
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "StigmaSwap", {setPos = 3, name = self:GetName(), hp = self:GetSpecialValueFor("hp_bonus"), atk = self:GetSpecialValueFor("atk_bonus") , def = self:GetSpecialValueFor("def_bonus") , crt = self:GetSpecialValueFor("crt_bonus")})
end

TeslaT = class({})
TeslaM = class({})
TeslaB = class({})
Tesla2Set = class({})
Tesla3Set = class({})
--MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE   

--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--
function TeslaT:IsHidden()return true end
function TeslaT:RemoveOnDeath() return false end
function TeslaT:IsPurgable()return false end

function TeslaT:checkSet()
	local caster = self:GetCaster()
	res = 1
	if caster:HasModifier("TeslaM") then
		res = res + 1
	end
	if caster:HasModifier("TeslaB") then
		res = res + 1
	end
	return res
end

function TeslaT:OnCreated()
	self.bonus_total_damage = self:GetAbility():GetSpecialValueFor("bonus_total_damage")
	self.hp_bonus = self:GetAbility():GetSpecialValueFor("hp_bonus")
	self.atk_bonus = self:GetAbility():GetSpecialValueFor("atk_bonus")
	self.def_bonus = self:GetAbility():GetSpecialValueFor("def_bonus")
	self.crt_bonus = self:GetAbility():GetSpecialValueFor("crt_bonus")
	if not IsServer() then return end
	local set = self:checkSet()
	local caster = self:GetCaster()
	if set == 2 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Tesla2Set", {})
	end
	if set == 3 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Tesla3Set", {})
	end
	self.buff = self:GetCaster():TakeItem(self:GetAbility())
end

function TeslaT:OnRefresh()
	self.bonus_total_damage = self:GetAbility():GetSpecialValueFor("bonus_total_damage")
	self:GetParent().stigmata_t = nil
end

function TeslaT:OnRemoved()
	self:GetParent().stigmata_t = nil
	if not IsServer() then return end
	self:GetParent():AddItem(self.buff)
	local set = self:checkSet()
	if set == 2 then
		self:GetCaster():RemoveModifierByName("Tesla2Set")
	end
	if set == 3 then
		self:GetCaster():RemoveModifierByName("Tesla3Set")
	end
end

function TeslaT:GetModifierTotalDamageOutgoing_Percentage(event)
	if event.target:IsSilenced() then
		return self.bonus_total_damage
	end
	return 0
end


function TeslaT:GetModifierHealthBonus()
	return self.hp_bonus
end

function TeslaT:GetModifierPreAttack_BonusDamage()
	return self.atk_bonus
end

function TeslaT:GetModifierPhysicalArmorBonus()
	return self.def_bonus
end
function TeslaT:GetModifierStatCRT_Bonus()
	return self.crt_bonus
end

function TeslaT:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
end

--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--

function TeslaM:IsHidden()return true end
function TeslaM:RemoveOnDeath() return false end

function TeslaM:OnCreated()
	self.bonus_total_damage = self:GetAbility():GetSpecialValueFor("bonus_total_damage")
	self.hp_bonus = self:GetAbility():GetSpecialValueFor("hp_bonus")
	self.atk_bonus = self:GetAbility():GetSpecialValueFor("atk_bonus")
	self.def_bonus = self:GetAbility():GetSpecialValueFor("def_bonus")
	self.crt_bonus = self:GetAbility():GetSpecialValueFor("crt_bonus")
	if not IsServer() then return end
	local set = self:checkSet()
	local caster = self:GetCaster()
	if set == 2 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Tesla2Set", {})
	end
	if set == 3 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Tesla3Set", {})
	end
	self.buff = caster:TakeItem(self:GetAbility())
end

function TeslaM:OnRefresh()
	self.bonus_total_damage = self:GetAbility():GetSpecialValueFor("bonus_total_damage")
	self:GetParent().stigmata_m = nil
end

function TeslaM:OnRemoved()
	self:GetParent().stigmata_m = nil
	if not IsServer() then return end
	self:GetParent():AddItem(self.buff)
	local set = self:checkSet()
	if set == 2 then
		self:GetCaster():RemoveModifierByName("Tesla2Set")
	end
	if set == 3 then
		self:GetCaster():RemoveModifierByName("Tesla3Set")
	end
end

function TeslaM:checkSet()
	local caster = self:GetCaster()
	res = 1
	if caster:HasModifier("TeslaT") then
		res = res + 1
	end
	if caster:HasModifier("TeslaB") then
		res = res + 1
	end
	return res
end

function TeslaM:GetModifierTotalDamageOutgoing_Percentage(event)
	if event.target:IsRooted() then
		return self.bonus_total_damage
	end
	return 0
end

function TeslaM:GetModifierHealthBonus()
	return self.hp_bonus
end

function TeslaM:GetModifierPreAttack_BonusDamage()
	return self.atk_bonus
end

function TeslaM:GetModifierPhysicalArmorBonus()
	return self.def_bonus
end
function TeslaM:GetModifierStatCRT_Bonus()
	return self.crt_bonus
end

function TeslaM:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
end
--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--

function TeslaB:IsHidden()return true end
function TeslaB:RemoveOnDeath() return false end
function TeslaB:IsPurgable()return false end

function TeslaB:OnCreated()
	self.bonus_total_damage = self:GetAbility():GetSpecialValueFor("bonus_total_damage")
	self.hp_bonus = self:GetAbility():GetSpecialValueFor("hp_bonus")
	self.atk_bonus = self:GetAbility():GetSpecialValueFor("atk_bonus")
	self.def_bonus = self:GetAbility():GetSpecialValueFor("def_bonus")
	self.crt_bonus = self:GetAbility():GetSpecialValueFor("crt_bonus")
	if not IsServer() then return end
	local set = self:checkSet()
	local caster = self:GetCaster()
	if set == 2 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Tesla2Set", {})
	end
	if set == 3 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Tesla3Set", {})
	end
	self.buff = self:GetCaster():TakeItem(self:GetAbility())
end

function TeslaB:OnRefresh()
	self.bonus_total_damage = self:GetAbility():GetSpecialValueFor("bonus_total_damage")
	self:GetParent().stigmata_b = nil
end

function TeslaB:OnRemoved()
	self:GetParent().stigmata_b = nil
	if not IsServer() then return end
	self:GetParent():AddItem(self.buff)
	local set = self:checkSet()
	if set == 2 then
		self:GetCaster():RemoveModifierByName("Tesla2Set")
	end
	if set == 3 then
		self:GetCaster():RemoveModifierByName("Tesla3Set")
	end
end

function TeslaB:checkSet()
	local caster = self:GetCaster()
	res = 1
	if caster:HasModifier("TeslaM") then
		res = res + 1
	end
	if caster:HasModifier("TeslaT") then
		res = res + 1
	end
	return res
end

function TeslaB:GetModifierTotalDamageOutgoing_Percentage(event)
	if event.target:IsStunned() then
		return self.bonus_total_damage
	end
	return 0
end

function TeslaB:GetModifierHealthBonus()
	return self.hp_bonus
end

function TeslaB:GetModifierPreAttack_BonusDamage()
	return self.atk_bonus
end

function TeslaB:GetModifierPhysicalArmorBonus()
	return self.def_bonus
end
function TeslaB:GetModifierStatCRT_Bonus()
	return self.crt_bonus
end

function TeslaB:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
end
--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--
function Tesla2Set:IsHidden()return true end
function Tesla2Set:RemoveOnDeath() return false end
function Tesla2Set:IsPurgable()return false end

function Tesla2Set:OnCreated()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 2, dispatch = "Tesla2Set"}) end
end

function Tesla2Set:OnDestroy()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 2, name = "Tesla2Set"}) end
end

function Tesla2Set:GetModifierTotalDamageOutgoing_Percentage(event)
	if event.target:PassivesDisabled() then
		return 15
	end
	return 0
end

function Tesla2Set:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE  ,
	}
end
--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--
function Tesla3Set:IsHidden()return true end
function Tesla3Set:RemoveOnDeath() return false end
function Tesla3Set:IsPurgable()return false end

function Tesla3Set:OnCreated()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 3, dispatch = "Tesla3Set"}) end
	
end

function Tesla3Set:OnDestroy()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 3, name = "Tesla3Set"}) end
	
end

function Tesla3Set:GetModifierBonusStats_LightningDamage()
	return 30
end

function Tesla3Set:DeclareFunctions()
	return {
		
	}
end
