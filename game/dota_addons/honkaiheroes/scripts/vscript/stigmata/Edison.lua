LinkLuaModifier( "EdisonT", "stigmata/Edison", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "EdisonM", "stigmata/Edison", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "EdisonB", "stigmata/Edison", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "Edison2Set", "stigmata/Edison", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "Edison3Set", "stigmata/Edison", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "EdisonTBuff", "stigmata/Edison", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "EdisonMBuff", "stigmata/Edison", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "EdisonBBuff", "stigmata/Edison", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "Edison2SetCD", "stigmata/Edison", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "Edison2SetBuff", "stigmata/Edison", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "EdisonBSlow", "stigmata/Edison", LUA_MODIFIER_MOTION_NONE )

item_EdisonT = class({})
item_EdisonM = class({})
item_EdisonB = class({})

function item_EdisonT:OnSpellStart()
	local caster = self:GetCaster()
	
	local mod = caster:AddNewModifier(caster, self, "EdisonT", {})
	if caster.stigmata_t then
		caster.stigmata_t:Destroy()
	end
	caster.stigmata_t = mod
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "StigmaSwap", {setPos = 1, name = self:GetName(), hp = self:GetSpecialValueFor("hp_bonus"), atk = self:GetSpecialValueFor("atk_bonus") , def = self:GetSpecialValueFor("def_bonus") , crt = self:GetSpecialValueFor("crt_bonus") })
end

function item_EdisonM:OnSpellStart()
	local caster = self:GetCaster()
	
	local mod = caster:AddNewModifier(caster, self, "EdisonM", {})
	if caster.stigmata_m then
		caster.stigmata_m:Destroy()
	end
	caster.stigmata_m = mod
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "StigmaSwap", {setPos = 2, name = self:GetName(), hp = self:GetSpecialValueFor("hp_bonus"), atk = self:GetSpecialValueFor("atk_bonus") , def = self:GetSpecialValueFor("def_bonus") , crt = self:GetSpecialValueFor("crt_bonus")})
end

function item_EdisonB:OnSpellStart()
	local caster = self:GetCaster()
	
	local mod = caster:AddNewModifier(caster, self, "EdisonB", {})
	if caster.stigmata_b then
		caster.stigmata_b:Destroy()
	end
	caster.stigmata_b = mod
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "StigmaSwap", {setPos = 3, name = self:GetName(), hp = self:GetSpecialValueFor("hp_bonus"), atk = self:GetSpecialValueFor("atk_bonus") , def = self:GetSpecialValueFor("def_bonus") , crt = self:GetSpecialValueFor("crt_bonus")})
end

EdisonT = class({})
EdisonM = class({})
EdisonB = class({})
Edison2Set = class({})
Edison3Set = class({})


--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--TOP--
function EdisonT:IsHidden()return true end
function EdisonT:RemoveOnDeath() return false end
function EdisonT:IsPurgable()return false end


function EdisonT:checkSet()
	local caster = self:GetCaster()
	res = 1
	if caster:HasModifier("EdisonM") then
		res = res + 1
	end
	if caster:HasModifier("EdisonB") then
		res = res + 1
	end
	return res
end

function EdisonT:OnCreated()
	self.lightning_bonus = self:GetAbility():GetSpecialValueFor("lightning_bonus")
	self.hp_bonus = self:GetAbility():GetSpecialValueFor("hp_bonus")
	self.atk_bonus = self:GetAbility():GetSpecialValueFor("atk_bonus")
	self.def_bonus = self:GetAbility():GetSpecialValueFor("def_bonus")
	self.crt_bonus = self:GetAbility():GetSpecialValueFor("crt_bonus")
	if not IsServer() then return end
	self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("proc_cd"))
	local set = self:checkSet()
	local caster = self:GetCaster()
	if set == 2 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Edison2Set", {})
	end
	if set == 3 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Edison3Set", {})
	end
	self.buff = self:GetCaster():TakeItem(self:GetAbility())
end

function EdisonT:OnIntervalThink()
	self:GetParent():AddNewModifier(self:GetCaster(), self.buff, "EdisonTBuff", {duration = self:GetAbility():GetSpecialValueFor("proc_cd")})
end

function EdisonT:OnRefresh()
	self:GetParent().stigmata_t = nil
end

function EdisonT:OnRemoved()
	self:GetParent().stigmata_t = nil
	if not IsServer() then return end
	self:GetParent():AddItem(self.buff)
	local set = self:checkSet()
	if set == 2 then
		self:GetCaster():RemoveModifierByName("Edison2Set")
	end
	if set == 3 then
		self:GetCaster():RemoveModifierByName("Edison3Set")
	end
end

function EdisonT:GetModifierBonusStats_LightningDamage()
	return self.lightning_bonus
end

function EdisonT:GetModifierHealthBonus()
	return self.hp_bonus
end

function EdisonT:GetModifierPreAttack_BonusDamage()
	return self.atk_bonus
end

function EdisonT:GetModifierPhysicalArmorBonus()
	return self.def_bonus
end
function EdisonT:GetModifierStatCRT_Bonus()
	return self.crt_bonus
end

function EdisonT:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

EdisonTBuff = class({})

function EdisonTBuff:IsHidden() return true end

function EdisonTBuff:DeclareFunctions()
	return {
	MODIFIER_EVENT_ON_ATTACK_LANDED  
	}
end

function EdisonTBuff:OnAttackLanded(event)
	if event.attacker ~= self:GetParent() or event.target == event.attacker then return end
	if event.damage_category == 1 then
		local damage = self:GetAbility():GetSpecialValueFor("proc_bonus")*event.attacker:GetAttackDamage()/100
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, event.target, damage, event.attacker:GetPlayerOwner())
		ApplyDamage({
		victim = event.target,
		attacker = event.attacker,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_MAGIC_AUTO_ATTACK,
		ability = self:GetAbility()
		})
		self:Destroy()
	end
end

--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--MID--

function EdisonM:IsHidden()return true end
function EdisonM:RemoveOnDeath() return false end
function EdisonM:IsPurgable()return false end

function EdisonM:OnCreated()
	self.lightning_bonus = self:GetAbility():GetSpecialValueFor("lightning_bonus")
	self.hp_bonus = self:GetAbility():GetSpecialValueFor("hp_bonus")
	self.atk_bonus = self:GetAbility():GetSpecialValueFor("atk_bonus")
	self.def_bonus = self:GetAbility():GetSpecialValueFor("def_bonus")
	self.crt_bonus = self:GetAbility():GetSpecialValueFor("crt_bonus")
	if not IsServer() then return end
	self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("proc_cd"))
	local set = self:checkSet()
	local caster = self:GetCaster()
	if set == 2 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Edison2Set", {})
	end
	if set == 3 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Edison3Set", {})
	end
	self.buff = caster:TakeItem(self:GetAbility())
end

function EdisonM:OnIntervalThink()
	self:GetParent():AddNewModifier(self:GetCaster(), self.buff, "EdisonMBuff", {duration = self:GetAbility():GetSpecialValueFor("proc_cd")})
end

function EdisonM:OnRefresh()
	self:GetParent().stigmata_m = nil
end

function EdisonM:OnRemoved()
	self:GetParent().stigmata_m = nil
	if not IsServer() then return end
	self:GetParent():AddItem(self.buff)
	local set = self:checkSet()
	if set == 2 then
		self:GetCaster():RemoveModifierByName("Edison2Set")
	end
	if set == 3 then
		self:GetCaster():RemoveModifierByName("Edison3Set")
	end
end

function EdisonM:checkSet()
	local caster = self:GetCaster()
	res = 1
	if caster:HasModifier("EdisonT") then
		res = res + 1
	end
	if caster:HasModifier("EdisonB") then
		res = res + 1
	end
	return res
end

function EdisonM:GetModifierBonusStats_LightningDamage()
	return self.lightning_bonus
end

function EdisonM:GetModifierHealthBonus()
	return self.hp_bonus
end

function EdisonM:GetModifierPreAttack_BonusDamage()
	return self.atk_bonus
end

function EdisonM:GetModifierPhysicalArmorBonus()
	return self.def_bonus
end
function EdisonM:GetModifierStatCRT_Bonus()
	return self.crt_bonus
end

function EdisonM:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

EdisonMBuff = class({})

function EdisonMBuff:IsHidden() return true end

function EdisonMBuff:DeclareFunctions()
	return {
	MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK   
	}
end

function EdisonMBuff:GetModifierPhysical_ConstantBlock(event)
	if event.target == event.attacker then return 0 end
	self:Destroy()
	return self:GetAbility():GetSpecialValueFor("proc_bonus")
end
--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--BOT--

function EdisonB:IsHidden()return true end
function EdisonB:RemoveOnDeath() return false end
function EdisonB:IsPurgable()return false end

function EdisonB:OnCreated()
	self.summon_bonus = self:GetAbility():GetSpecialValueFor("summon_bonus")
	self.hp_bonus = self:GetAbility():GetSpecialValueFor("hp_bonus")
	self.atk_bonus = self:GetAbility():GetSpecialValueFor("atk_bonus")
	self.def_bonus = self:GetAbility():GetSpecialValueFor("def_bonus")
	self.crt_bonus = self:GetAbility():GetSpecialValueFor("crt_bonus")
	if not IsServer() then return end
	self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("proc_cd"))
	local set = self:checkSet()
	local caster = self:GetCaster()
	if set == 2 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Edison2Set", {})
	end
	if set == 3 then
		caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "Edison3Set", {})
	end
	self.buff = self:GetCaster():TakeItem(self:GetAbility())
end

function EdisonB:OnIntervalThink()
	self:GetParent():AddNewModifier(self:GetCaster(), self.buff, "EdisonBBuff", {duration = self:GetAbility():GetSpecialValueFor("proc_cd")})
end

function EdisonB:OnRefresh()
	self:GetParent().stigmata_b = nil
end

function EdisonB:OnRemoved()
	self:GetParent().stigmata_b = nil
	if not IsServer() then return end
	self:GetParent():AddItem(self.buff)
	local set = self:checkSet()
	if set == 2 then
		self:GetCaster():RemoveModifierByName("Edison2Set")
	end
	if set == 3 then
		self:GetCaster():RemoveModifierByName("Edison3Set")
	end
end

function EdisonB:checkSet()
	local caster = self:GetCaster()
	res = 1
	if caster:HasModifier("EdisonM") then
		res = res + 1
	end
	if caster:HasModifier("EdisonT") then
		res = res + 1
	end
	return res
end

function EdisonB:GetModifierBonusStat_SummonBonus()
	return self.summon_bonus
end

function EdisonB:GetModifierHealthBonus()
	return self.hp_bonus;
end

function EdisonB:GetModifierPreAttack_BonusDamage()
	return self.atk_bonus
end

function EdisonB:GetModifierPhysicalArmorBonus()
	return self.def_bonus
end
function EdisonB:GetModifierStatCRT_Bonus()
	return self.crt_bonus
end

function EdisonB:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

EdisonBBuff = class({})

function EdisonBBuff:IsHidden() return true end

function EdisonBBuff:DeclareFunctions()
	return {
	MODIFIER_EVENT_ON_ATTACK_LANDED  
	}
end

function EdisonBBuff:OnAttackLanded(event)
	if event.attacker ~= self:GetParent() or event.target == event.attacker then return end
	if event.damage_category == 1 then
		event.target:AddNewModifier(event.attacker, self:GetAbility(), "EdisonBSlow", {duration = self:GetAbility():GetSpecialValueFor("slow_duration")})
		self:Destroy()
	end
end

EdisonBSlow = class({})

function EdisonBSlow:IsDebuff() return true end

function EdisonBSlow:OnCreated()
	self.movespeed_bonus = self:GetAbility():GetSpecialValueFor("movespeed_bonus")
end

function EdisonBSlow:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end

function EdisonBSlow:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed_bonus
end

--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--2SET--
function Edison2Set:IsHidden()return true end
function Edison2Set:RemoveOnDeath() return false end
function Edison2Set:IsPurgable()return false end

function Edison2Set:OnCreated()
	if IsServer() then
		self:StartIntervalThink(12)
		CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 2, dispatch = "Edison2Set"}) 
	end
end

function Edison2Set:OnIntervalThink()
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "Edison2SetCD", {duration = 12})
end

function Edison2Set:OnDestroy()
	if IsServer() then 
		CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 2, name = "Edison2Set"}) 
	end
end

Edison2SetCD = class({})

function Edison2SetCD:IsHidden() return true end

function Edison2SetCD:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
end

function Edison2SetCD:GetModifierTotalDamageOutgoing_Percentage(event)
	print("Daemend")
	if event.target == event.attacker then return 0 end
	if event.damage_category == 1 then
		event.attacker:AddNewModifier(event.attacker, self:GetAbility(), "Edison2SetBuff", {duration = 6})
		self:Destroy()
		return 50
	end
end


Edison2SetBuff = class({})

function Edison2SetBuff:DeclareFunctions()
	return {
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE    
	}
end

function Edison2SetBuff:GetModifierTotalDamageOutgoing_Percentage(event)
	return 15
end
--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--3SET--
function Edison3Set:IsHidden()return true end
function Edison3Set:RemoveOnDeath() return false end
function Edison3Set:IsPurgable()return false end

function Edison3Set:OnCreated()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 3, dispatch = "Edison3Set"}) end
end

function Edison3Set:OnDestroy()
	if IsServer() then CustomGameEventManager:Send_ServerToPlayer(self:GetParent():GetPlayerOwner(), "StigmaSetGain", {set = 3, name = "Edison3Set"}) end
end

function Edison3Set:DeclareFunctions()
	return {}
end

function Edison3Set:GetModifierBonusStats_LightningDamage()
	return 25
end
