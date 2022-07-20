LinkLuaModifier("modifier_jingweiwings_activated","items/item_jingweiswings",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jingweiwings_debuff","items/item_jingweiswings",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jingweiwings_crit","items/item_jingweiswings",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jingweiwings_buff","items/item_jingweiswings",LUA_MODIFIER_MOTION_NONE)
item_jingweiswings = class({})

function item_jingweiswings:Precache()
	--PrecacheResource( "soundfile", "soundevents/", context )
end

function item_jingweiswings:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_jingweiwings_activated",{duration = self:GetDuration()})
end

function item_jingweiswings:GetCastRange()
	return self:GetCaster():Script_GetAttackRange() + self:GetSpecialValueFor("bonus_radius")
end
function item_jingweiswings:GetIntrinsicModifierName()
    return "modifier_jingweiwings_crit"
end

modifier_jingweiwings_activated = class({})

function modifier_jingweiwings_activated:OnCreated(kv)
	
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.radius = self.ability:GetSpecialValueFor("bonus_radius")
	local dot_duration = self.ability:GetSpecialValueFor("dot_duration")
	if not IsServer() then return end
	self:StartIntervalThink(dot_duration)
end

function modifier_jingweiwings_activated:OnIntervalThink()
	local enemies = FindUnitsInRadius(
		self.caster:GetTeamNumber(),	-- int, your team number
		self.caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.caster:Script_GetAttackRange() + self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,enemy in pairs(enemies) do
		if enemy~=self:GetParent() then
			ApplyDamage({
						victim = enemy,
						attacker = self.caster,
						damage = self.ability:GetSpecialValueFor("damage_pct")/100*self.caster:GetBaseDamageMax(),
						damage_type = self.ability:GetAbilityDamageType(),
						ability = self.ability})
			enemy:AddNewModifier(self.caster, self.ability, "modifier_jingweiwings_debuff", {duration = self.ability:GetSpecialValueFor("dot_duration")})
			break
		end
	end
	
end

modifier_jingweiwings_debuff = class({})

function modifier_jingweiwings_debuff:OnCreated(kv)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	local damage = self.ability:GetSpecialValueFor( "damage" )
	
	if not IsServer() then return end

	self.damageTable = {
		victim = self.parent,
		attacker = self.caster,
		damage = damage,
		damage_type = self.ability:GetAbilityDamageType(),
		ability = self.ability, --Optional.
	}

	-- Start interval
	self:StartIntervalThink( self.ability:GetSpecialValueFor("dot_speed"))
end

function modifier_jingweiwings_debuff:GetEffectName()
	return "particles/units/heroes/hero_invoker/invoker_chaos_meteor_burn_debuff.vpcf"
end

function modifier_jingweiwings_debuff:OnIntervalThink()
	ApplyDamage(self.damageTable)
	--self:PlayEffects()

end

modifier_jingweiwings_crit = class({})

function modifier_jingweiwings_crit:OnCreated( kv )
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_rate" )
	self.crit_bonus = self:GetAbility():GetSpecialValueFor( "crit_dmg" )
	self.max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")
end

function modifier_jingweiwings_crit:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_ATTACK
	}
	return func
end
function modifier_jingweiwings_crit:OnAttack(kv)
	if IsServer() and kv.attacker==self:GetParent() then
		if self.currentTarget==kv.target then
			self:AddStack()
		else
			self:SetStackCount(1)
			self.currentTarget = kv.target
		end
	end
end

function modifier_jingweiwings_crit:AddStack()
	if self:GetStackCount() < self.max_stacks then
		self:IncrementStackCount()
	end
end

function modifier_jingweiwings_crit:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() then
		if RollPercentage( self:GetStackCount()*self.crit_chance ) then
			self.record = params.record
			return self:GetStackCount()*self.crit_bonus+100
		end
	end
end

function modifier_jingweiwings_crit:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record then
			self.record = nil
			--self:PlayEffects( params.target )
		end
	end
end

modifier_jingweiwings_buff = class({})


