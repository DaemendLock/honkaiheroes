LinkLuaModifier( "AttilaT", "stigmata/Attila", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "AttilaM", "stigmata/Attila", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "AttilaB", "stigmata/Attila", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "Attila2Set", "stigmata/Attila", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "Attila3Set", "stigmata/Attila", LUA_MODIFIER_MOTION_NONE )


item_AttilaT = class({})
item_AttilaM = class({})
item_AttilaB = class({})

function item_AttilaT:OnSpellStart()
	local caster = self:GetCaster()
	
	local mod = caster:AddNewModifier(caster, self, "AttilaT", {})
	if caster.stigmata_t then
		caster.stigmata_t:Destroy()
	end
	caster.stigmata_t = mod
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "StigmaSwap", {setPos = 1, name = self:GetName(), hp = self:GetSpecialValueFor("hp_bonus"), atk = self:GetSpecialValueFor("atk_bonus") , def = self:GetSpecialValueFor("def_bonus") , crt = self:GetSpecialValueFor("crt_bonus") })
end

function item_AttilaM:OnSpellStart()
	local caster = self:GetCaster()
	
	local mod = caster:AddNewModifier(caster, self, "AttilaM", {})
	if caster.stigmata_m then
		caster.stigmata_m:Destroy()
	end
	caster.stigmata_m = mod
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "StigmaSwap", {setPos = 2, name = self:GetName(), hp = self:GetSpecialValueFor("hp_bonus"), atk = self:GetSpecialValueFor("atk_bonus") , def = self:GetSpecialValueFor("def_bonus") , crt = self:GetSpecialValueFor("crt_bonus")})
end

function item_AttilaB:OnSpellStart()
	local caster = self:GetCaster()
	
	local mod = caster:AddNewModifier(caster, self, "AttilaB", {})
	if caster.stigmata_b then
		caster.stigmata_b:Destroy()
	end
	caster.stigmata_b = mod
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "StigmaSwap", {setPos = 3, name = self:GetName(), hp = self:GetSpecialValueFor("hp_bonus"), atk = self:GetSpecialValueFor("atk_bonus") , def = self:GetSpecialValueFor("def_bonus") , crt = self:GetSpecialValueFor("crt_bonus")})
end

AttilaT = class({})
AttilaM = class({})
AttilaB = class({})
Attila2Set = class({})
Attila3Set = class({})


--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--
function AttilaT:IsHidden()return true end
function AttilaT:RemoveOnDeath() return false end
function AttilaT:IsPurgable()return false end

function AttilaT:checkSet()
	local caster = self:GetCaster()
	res = 1
	if caster:HasModifier("AttilaM") then
		res = res + 1
	end
	if caster:HasModifier("AttilaB") then
		res = res + 1
	end
	return res
end

function AttilaT:OnCreated()
	self.buff_val = self:GetAbility():GetSpecialValueFor("buff_val")
	self.combo_count = self:GetAbility():GetSpecialValueFor("combo_count")
	self.hp_bonus = self:GetAbility():GetSpecialValueFor("hp_bonus")
	self.atk_bonus = self:GetAbility():GetSpecialValueFor("atk_bonus")
	self.def_bonus = self:GetAbility():GetSpecialValueFor("def_bonus")
	self.crt_bonus = self:GetAbility():GetSpecialValueFor("crt_bonus")
	if not IsServer() then return end
	local set = self:checkSet()
	local caster = self:GetCaster()
	if set == 2 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Attila2Set", {})
	end
	if set == 3 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Attila3Set", {})
	end
	self.buff = self:GetCaster():TakeItem(self:GetAbility())
end

function AttilaT:OnRefresh()

	self:GetParent().stigmata_t = nil
end

function AttilaT:OnRemoved()
	self:GetParent().stigmata_t = nil
	if not IsServer() then return end
	self:GetParent():AddItem(self.buff)
	local set = self:checkSet()
	if set == 2 then
		self:GetCaster():RemoveModifierByName("Attila2Set")
	end
	if set == 3 then
		self:GetCaster():RemoveModifierByName("Attila3Set")
	end
end

function AttilaT:GetModifierMoveSpeedBonus_Percentage()
	if self:GetCaster().combo_hit:GetStackCount() > self.combo_count then return self.buff_val end
	return 0
end

function AttilaT:GetModifierHealthBonus()
	return self.hp_bonus
end

function AttilaT:GetModifierPreAttack_BonusDamage()
	return self.atk_bonus
end

function AttilaT:GetModifierPhysicalArmorBonus()
	return self.def_bonus
end
function AttilaT:GetModifierStatCRT_Bonus()
	return self.crt_bonus
end

function AttilaT:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--

function AttilaM:IsHidden()return true end
function AttilaM:RemoveOnDeath() return false end
function AttilaM:IsPurgable()return false end

function AttilaM:OnCreated()
	self.buff_val = self:GetAbility():GetSpecialValueFor("buff_val")
	self.combo_count = self:GetAbility():GetSpecialValueFor("combo_count")
	self.hp_bonus = self:GetAbility():GetSpecialValueFor("hp_bonus")
	self.atk_bonus = self:GetAbility():GetSpecialValueFor("atk_bonus")
	self.def_bonus = self:GetAbility():GetSpecialValueFor("def_bonus")
	self.crt_bonus = self:GetAbility():GetSpecialValueFor("crt_bonus")
	if not IsServer() then return end
	local set = self:checkSet()
	local caster = self:GetCaster()
	if set == 2 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Attila2Set", {})
	end
	if set == 3 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Attila3Set", {})
	end
	self.buff = caster:TakeItem(self:GetAbility())
end

function AttilaM:OnRefresh()
	self.buff_val = self:GetAbility():GetSpecialValueFor("buff_val")
	self.combo_count = self:GetAbility():GetSpecialValueFor("combo_count")
	self:GetParent().stigmata_m = nil
end

function AttilaM:OnRemoved()
	self:GetParent().stigmata_m = nil
	if not IsServer() then return end
	self:GetParent():AddItem(self.buff)
	local set = self:checkSet()
	if set == 2 then
		self:GetCaster():RemoveModifierByName("Attila2Set")
	end
	if set == 3 then
		self:GetCaster():RemoveModifierByName("Attila3Set")
	end
end

function AttilaM:checkSet()
	local caster = self:GetCaster()
	res = 1
	if caster:HasModifier("AttilaT") then
		res = res + 1
	end
	if caster:HasModifier("AttilaB") then
		res = res + 1
	end
	return res
end

function AttilaM:GetModifierPhysicalArmorTotal_Percentage()
	if self:GetCaster().combo_hit:GetStackCount() > self.combo_count then return self.buff_val end
	return 0
end

function AttilaM:GetModifierHealthBonus()
	return self.hp_bonus;
end

function AttilaM:GetModifierPreAttack_BonusDamage()
	return self.atk_bonus
end

function AttilaM:GetModifierPhysicalArmorBonus()
	return self.def_bonus
end
function AttilaM:GetModifierStatCRT_Bonus()
	return self.crt_bonus
end

function AttilaM:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_TOTAL_PERCENTAGE 
	}
end

--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--

function AttilaB:IsHidden()return true end
function AttilaB:RemoveOnDeath() return false end
function AttilaB:IsPurgable()return false end

function AttilaB:OnCreated()
	self.buff_val = self:GetAbility():GetSpecialValueFor("buff_val")
	self.combo_count = self:GetAbility():GetSpecialValueFor("combo_count")
	self.hp_bonus = self:GetAbility():GetSpecialValueFor("hp_bonus")
	self.atk_bonus = self:GetAbility():GetSpecialValueFor("atk_bonus")
	self.def_bonus = self:GetAbility():GetSpecialValueFor("def_bonus")
	self.crt_bonus = self:GetAbility():GetSpecialValueFor("crt_bonus")
	if not IsServer() then return end
	local set = self:checkSet()
	local caster = self:GetCaster()
	if set == 2 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Attila2Set", {})
	end
	if set == 3 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Attila3Set", {})
	end
	self.buff = self:GetCaster():TakeItem(self:GetAbility())
end

function AttilaB:OnRefresh()
	self.buff_val = self:GetAbility():GetSpecialValueFor("buff_val")
	self.combo_count = self:GetAbility():GetSpecialValueFor("combo_count")
	self:GetParent().stigmata_b = nil
end

function AttilaB:OnRemoved()
	self:GetParent().stigmata_b = nil
	if not IsServer() then return end
	self:GetParent():AddItem(self.buff)
	local set = self:checkSet()
	if set == 2 then
		self:GetCaster():RemoveModifierByName("Attila2Set")
	end
	if set == 3 then
		self:GetCaster():RemoveModifierByName("Attila3Set")
	end
end

function AttilaB:checkSet()
	local caster = self:GetCaster()
	res = 1
	if caster:HasModifier("AttilaM") then
		res = res + 1
	end
	if caster:HasModifier("AttilaT") then
		res = res + 1
	end
	return res
end

function AttilaB:GetModifierBonusStats_PhysicalDamage()
	if self:GetCaster().combo_hit:GetStackCount() > self.combo_count then return self.buff_val end
	return 0
end

function AttilaB:GetModifierHealthBonus()
	return self.hp_bonus;
end

function AttilaB:GetModifierPreAttack_BonusDamage()
	return self.atk_bonus
end

function AttilaB:GetModifierPhysicalArmorBonus()
	return self.def_bonus
end
function AttilaB:GetModifierStatCRT_Bonus()
	return self.crt_bonus
end

function AttilaB:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end


--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--
function Attila2Set:IsHidden()return true end
function Attila2Set:RemoveOnDeath() return false end
function Attila2Set:IsPurgable()return false end

function Attila2Set:OnCreated()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 2, dispatch = "Attila2Set"}) end
end

function Attila2Set:OnDestroy()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 2, name = "Attila2Set"}) end
end

function Attila2Set:GetModifierBonusStat_CritDamage()
	return 30
end

function Attila2Set:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_EXTRA_MANA_PERCENTAGE,
	}
end

function Attila2Set:GetModifierExtraManaPercentage(event)
	if self:GetParent():GetPrimaryAttribute() == DOTA_ATTRIBUTE_AGILITY then
	return 10
	end
	return 0
end

--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--
function Attila3Set:IsHidden()return true end
function Attila3Set:RemoveOnDeath() return false end
function Attila3Set:IsPurgable()return false end

function Attila3Set:OnCreated()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 3, dispatch = "Attila3Set"}) end
end

function Attila3Set:GetModifierStatCRT_Bonus()
	return 5
end	

function Attila3Set:OnDestroy()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 3, name = "Attila3Set"}) end
end

