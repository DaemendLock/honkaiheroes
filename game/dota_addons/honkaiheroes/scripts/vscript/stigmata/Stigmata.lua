LinkLuaModifier( "StigmatanameT", "stigmata/Stigmataname", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "StigmatanameM", "stigmata/Stigmataname", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "StigmatanameB", "stigmata/Stigmataname", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "Stigmataname2Set", "stigmata/Stigmataname", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "Stigmataname3Set", "stigmata/Stigmataname", LUA_MODIFIER_MOTION_NONE )

item_StigmatanameT = class({})
item_StigmatanameM = class({})
item_StigmatanameB = class({})

function item_StigmatanameT:OnSpellStart()
	local caster = self:GetCaster()
	
	local mod = caster:AddNewModifier(caster, self, "StigmatanameT", {})
	if caster.stigmata_t then
		caster.stigmata_t:Destroy()
	end
	caster.stigmata_t = mod
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "StigmaSwap", {setPos = 1, name = self:GetName(), hp = self:GetSpecialValueFor("hp_bonus"), atk = self:GetSpecialValueFor("atk_bonus") , def = self:GetSpecialValueFor("def_bonus") , crt = self:GetSpecialValueFor("crt_bonus") })
end

function item_StigmatanameM:OnSpellStart()
	local caster = self:GetCaster()
	
	local mod = caster:AddNewModifier(caster, self, "StigmatanameM", {})
	if caster.stigmata_m then
		caster.stigmata_m:Destroy()
	end
	caster.stigmata_m = mod
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "StigmaSwap", {setPos = 2, name = self:GetName(), hp = self:GetSpecialValueFor("hp_bonus"), atk = self:GetSpecialValueFor("atk_bonus") , def = self:GetSpecialValueFor("def_bonus") , crt = self:GetSpecialValueFor("crt_bonus")})
end

function item_StigmatanameB:OnSpellStart()
	local caster = self:GetCaster()
	
	local mod = caster:AddNewModifier(caster, self, "StigmatanameB", {})
	if caster.stigmata_b then
		caster.stigmata_b:Destroy()
	end
	caster.stigmata_b = mod
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "StigmaSwap", {setPos = 3, name = self:GetName(), hp = self:GetSpecialValueFor("hp_bonus"), atk = self:GetSpecialValueFor("atk_bonus") , def = self:GetSpecialValueFor("def_bonus") , crt = self:GetSpecialValueFor("crt_bonus")})
end

StigmatanameT = class({})
StigmatanameM = class({})
StigmatanameB = class({})
Stigmataname2Set = class({})
Stigmataname3Set = class({})


--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--
function StigmatanameT:IsHidden()return true end
function StigmatanameT:RemoveOnDeath() return false end
function StigmatanameT:IsPurgable()return false end

function StigmatanameT:checkSet()
	local caster = self:GetCaster()
	res = 1
	if caster:HasModifier("StigmatanameM") then
		res = res + 1
	end
	if caster:HasModifier("StigmatanameB") then
		res = res + 1
	end
	return res
end

function StigmatanameT:OnCreated()
	self.special_var = self:GetAbility():GetSpecialValueFor("special_var")
	self.hp_bonus = self:GetAbility():GetSpecialValueFor("hp_bonus")
	self.atk_bonus = self:GetAbility():GetSpecialValueFor("atk_bonus")
	self.def_bonus = self:GetAbility():GetSpecialValueFor("def_bonus")
	self.crt_bonus = self:GetAbility():GetSpecialValueFor("crt_bonus")
	if not IsServer() then return end
	local set = self:checkSet()
	local caster = self:GetCaster()
	if set == 2 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Stigmataname2Set", {})
	end
	if set == 3 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Stigmataname3Set", {})
	end
	self.buff = self:GetCaster():TakeItem(self:GetAbility())
end

function StigmatanameT:OnRefresh()
	self.special_var = self:GetAbility():GetSpecialValueFor("special_var")
	self:GetParent().stigmata_t = nil
end

function StigmatanameT:OnRemoved()
	self:GetParent().stigmata_t = nil
	if not IsServer() then return end
	self:GetParent():AddItem(self.buff)
	local set = self:checkSet()
	if set == 2 then
		self:GetCaster():RemoveModifierByName("Stigmataname2Set")
	end
	if set == 3 then
		self:GetCaster():RemoveModifierByName("Stigmataname3Set")
	end
end

function StigmatanameT:GetModifierHealthBonus()
	return self.hp_bonus
end

function StigmatanameT:GetModifierPreAttack_BonusDamage()
	return self.atk_bonus
end

function StigmatanameT:GetModifierPhysicalArmorBonus()
	return self.def_bonus
end
function StigmatanameT:GetModifierStatCRT_Bonus()
	return self.crt_bonus
end

function StigmatanameT:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--

function StigmatanameM:IsHidden()return true end
function StigmatanameM:RemoveOnDeath() return false end
function StigmatanameM:IsPurgable()return false end

function StigmatanameM:OnCreated()
	self.special_var = self:GetAbility():GetSpecialValueFor("special_var")
	self.hp_bonus = self:GetAbility():GetSpecialValueFor("hp_bonus")
	self.atk_bonus = self:GetAbility():GetSpecialValueFor("atk_bonus")
	self.def_bonus = self:GetAbility():GetSpecialValueFor("def_bonus")
	self.crt_bonus = self:GetAbility():GetSpecialValueFor("crt_bonus")
	if not IsServer() then return end
	local set = self:checkSet()
	local caster = self:GetCaster()
	if set == 2 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Stigmataname2Set", {})
	end
	if set == 3 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Stigmataname3Set", {})
	end
	self.buff = caster:TakeItem(self:GetAbility())
end

function StigmatanameM:OnRefresh()
	self.special_var = self:GetAbility():GetSpecialValueFor("special_var")
	self:GetParent().stigmata_m = nil
end

function StigmatanameM:OnRemoved()
	self:GetParent().stigmata_m = nil
	if not IsServer() then return end
	self:GetParent():AddItem(self.buff)
	local set = self:checkSet()
	if set == 2 then
		self:GetCaster():RemoveModifierByName("Stigmataname2Set")
	end
	if set == 3 then
		self:GetCaster():RemoveModifierByName("Stigmataname3Set")
	end
end

function StigmatanameM:checkSet()
	local caster = self:GetCaster()
	res = 1
	if caster:HasModifier("StigmatanameT") then
		res = res + 1
	end
	if caster:HasModifier("StigmatanameB") then
		res = res + 1
	end
	return res
end

function StigmatanameM:GetModifierHealthBonus()
	return self.hp_bonus;
end

function StigmatanameM:GetModifierPreAttack_BonusDamage()
	return self.atk_bonus
end

function StigmatanameM:GetModifierPhysicalArmorBonus()
	return self.def_bonus
end
function StigmatanameM:GetModifierStatCRT_Bonus()
	return self.crt_bonus
end

function StigmatanameM:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--

function StigmatanameB:IsHidden()return true end
function StigmatanameB:RemoveOnDeath() return false end
function StigmatanameB:IsPurgable()return false end

function StigmatanameB:OnCreated()
	self.special_var = self:GetAbility():GetSpecialValueFor("special_var")
	self.hp_bonus = self:GetAbility():GetSpecialValueFor("hp_bonus")
	self.atk_bonus = self:GetAbility():GetSpecialValueFor("atk_bonus")
	self.def_bonus = self:GetAbility():GetSpecialValueFor("def_bonus")
	self.crt_bonus = self:GetAbility():GetSpecialValueFor("crt_bonus")
	if not IsServer() then return end
	local set = self:checkSet()
	local caster = self:GetCaster()
	if set == 2 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Stigmataname2Set", {})
	end
	if set == 3 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Stigmataname3Set", {})
	end
	self.buff = self:GetCaster():TakeItem(self:GetAbility())
end

function StigmatanameB:OnRefresh()
	self.special_var = self:GetAbility():GetSpecialValueFor("special_var")
	self:GetParent().stigmata_b = nil
end

function StigmatanameB:OnRemoved()
	self:GetParent().stigmata_b = nil
	if not IsServer() then return end
	self:GetParent():AddItem(self.buff)
	local set = self:checkSet()
	if set == 2 then
		self:GetCaster():RemoveModifierByName("Stigmataname2Set")
	end
	if set == 3 then
		self:GetCaster():RemoveModifierByName("Stigmataname3Set")
	end
end

function StigmatanameB:checkSet()
	local caster = self:GetCaster()
	res = 1
	if caster:HasModifier("StigmatanameM") then
		res = res + 1
	end
	if caster:HasModifier("StigmatanameT") then
		res = res + 1
	end
	return res
end

function StigmatanameB:GetModifierHealthBonus()
	return self.hp_bonus;
end

function StigmatanameB:GetModifierPreAttack_BonusDamage()
	return self.atk_bonus
end

function StigmatanameB:GetModifierPhysicalArmorBonus()
	return self.def_bonus
end
function StigmatanameB:GetModifierStatCRT_Bonus()
	return self.crt_bonus
end

function StigmatanameB:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end


--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--
function Stigmataname2Set:IsHidden()return true end
function Stigmataname2Set:RemoveOnDeath() return false end
function Stigmataname2Set:IsPurgable()return false end

function Stigmataname2Set:OnCreated()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 2, dispatch = "Stigmataname2Set"}) end
end

function Stigmataname2Set:OnDestroy()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 2, name = "Stigmataname2Set"}) end
end


--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--
function Stigmataname3Set:IsHidden()return true end
function Stigmataname3Set:RemoveOnDeath() return false end
function Stigmataname3Set:IsPurgable()return false end

function Stigmataname3Set:OnCreated()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 3, dispatch = "Stigmataname3Set"}) end
end

function Stigmataname3Set:OnDestroy()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 3, name = "Stigmataname3Set"}) end
end

