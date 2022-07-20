LinkLuaModifier("modifier_jingwei","elfs/jingwei.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jingwei_ult","elfs/jingwei.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_elf","elfs/elf.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jingwei_firefairy", "elfs/jingwei.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jingwei_blazingpinion", "elfs/jingwei.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jingwei_recuperation", "elfs/jingwei.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ult_cd", "elfs/elf.lua", LUA_MODIFIER_MOTION_NONE)

item_jingwei = class({})

function item_jingwei.OnSpellStart(self)
    local caster = self.GetCaster(self)
    local PID = caster.GetPlayerOwnerID(caster)
    local hero = PlayerResource.GetSelectedHeroEntity(PlayerResource,PID)
    if hero.elf ~= nil then
		hero.elf:RespawnUnit()
		hero.elf:RemoveModifierByName("modifier_elf")
		hero.elf = nil
	end
	self:SpendCharge()
	local newElf = CreateUnitByName("jingwei",hero.GetAbsOrigin(hero),true,hero,hero.GetPlayerOwner(hero),hero.GetTeamNumber(hero))
	newElf.SetControllableByPlayer(newElf,PID,false)
    newElf.SetOwner(newElf,caster.GetOwner(caster))
    newElf.AddNewModifier(newElf,hero,self,"modifier_phased",{["duration"]=0.1})
    newElf.AddNewModifier(newElf,hero,self,"modifier_elf",{})
	newElf:SetUnitCanRespawn(true)
	newElf:SetMana(50)
    hero.elf=newElf
	
end

blazingpinion = class({})
modifier_jingwei_blazingpinion = class({})

function modifier_jingwei_blazingpinion:GetModifierOverrideAttackDamage()
	return self:GetCaster():GetAttackDamage()*4*(1+(self:GetAbility():GetSpecialValueFor("damage_buff")/100))
end
function modifier_jingwei_blazingpinion:OnAttackLanded(tb)
	if tb.attacker == self:GetCaster() then
		tb.attacker:GiveMana(self:GetAbility():GetSpecialValueFor("sp_restore"))
	end
end

function modifier_jingwei_blazingpinion:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ATTACK_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function blazingpinion:GetIntrinsicModifierName()
    return "modifier_jingwei_blazingpinion"
end

legacyofstarfire = class({})
modifier_jingwei_ult = class({})

function legacyofstarfire:OnOwnerSpawned()
	self:GetOwner():SetMana(50)
end
function legacyofstarfire:Spawn()
	if IsServer() then
        self:SetLevel(0)
    end
end

function legacyofstarfire:OnAbilityPhaseStart()
	local caster = self:GetOwner()
	local owner = caster:FindModifierByName("modifier_elf"):GetCaster()
	if caster:GetBaseAttackRange()<(caster:GetOrigin()- owner:GetOrigin()):Length2D() then
		self:GetCustomCastError()
		return false
	end
	return true
end

function legacyofstarfire:OnSpellStart()
	local caster = self:GetOwner()
	local owner = caster:FindModifierByName("modifier_elf"):GetCaster()
	owner:AddNewModifier(caster, self,"modifier_jingwei_ult", {duration = self:GetDuration()})
	owner:AddNewModifier(caster, self,"ult_cd", {duration = self:GetCooldown(1)})
	if caster:HasModifier("modifier_jingwei_recuperation") then
		owner:Heal(270*1.24, caster)
	end
end

function modifier_jingwei_ult:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink(self:GetDuration()/5)
end

function modifier_jingwei_ult:OnIntervalThink()
	self:GetParent():Heal(self:GetAbility():GetSpecialValueFor("healing"), self:GetCaster())
end

function modifier_jingwei_ult:OnRemoved()
	if not IsServer() then return end
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	
		self:GetParent():GetOrigin(),	
		nil,	
		250,	
		DOTA_UNIT_TARGET_TEAM_ENEMY,	
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
		0,	
		0,	
		false
	)
	local damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = self:GetCaster():GetAttackDamage()*self:GetAbility():GetAbilityDamage(),
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- apply damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)
	end

	-- play effects
	local sound_cast = "Hero_Lina.DragonSlave"
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
	--particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant.vpcf
end

firefairy = class({})
modifier_jingwei_firefairy = class({})

function firefairy:OnOwnerSpawned()

end

function firefairy:GetIntrinsicModifierName()
    return "modifier_jingwei_firefairy"
end

function modifier_jingwei_firefairy:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
	return funcs
end

function modifier_jingwei_firefairy:GetModifierSpellAmplify_Percentage()
	return self:GetAbility():GetSpecialValueFor("fire_buff")
end

function modifier_jingwei_firefairy:GetModifierHealAmplify_PercentageTarget()
	return self:GetAbility():GetSpecialValueFor("heal_buff")
end

recuperation = class({})
modifier_jingwei_recuperation = class({})

function recuperation:GetIntrinsicModifierName()
    return "modifier_jingwei_recuperation"
end

firesignet = class({})

function firesignet:Spawn()
	if IsServer() then
        self:SetLevel(0)
    end
end

function firesignet:OnOwnerSpawned()

end

modifier_jingwei = class({})

function modifier_jingwei:DeclareFunctions()
	local funcs = {
		--MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		
	}
	return funcs
end