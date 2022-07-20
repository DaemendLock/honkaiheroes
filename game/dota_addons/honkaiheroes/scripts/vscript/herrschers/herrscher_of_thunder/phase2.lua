--//PHASE-2 (1000HC)
--	//		-100% MELEE DAMAGE
--	//		CAST ABILITY : LIGHTNING MIRAGE - CREATES LIGHTNING ILLUSION WHICH EXPLODE WHEN ENEMY NEARBY AND STUNS ENEMY
--	//		CAST ABILITY : Herrscher form
--	//		CAST ABILITY : STATIC CHARGE CD: 15SEC
	


LinkLuaModifier( "modifier_lightning_remnant_thinker", "herrschers/herrscher_of_thunder/phase2", LUA_MODIFIER_MOTION_NONE )

hot_lightning_illusion = class({})

function hot_lightning_illusion:OnSpellStart()
	local caster = self:GetCaster()

	local duration = self:GetDuration()
	CreateModifierThinker(
		caster,
		self, 
		"modifier_lightning_remnant_thinker", 
		{ duration = duration }, -- kv
		caster:GetOrigin(),
		caster:GetTeamNumber(),
		false
	)
end

modifier_lightning_remnant_thinker = class({})

function modifier_lightning_remnant_thinker:IsHidden()
	return false
end

function modifier_lightning_remnant_thinker:IsPurgable()
	return false
end

function modifier_lightning_remnant_thinker:OnCreated( kv )
	self.parent = self:GetParent()
	self.caster = self:GetCaster()

	self.trigger = self:GetAbility():GetSpecialValueFor( "lightning_remnant_radius" )
	self.radius = self:GetAbility():GetSpecialValueFor( "lightning_remnant_damage_radius" )
	local damage = self:GetAbility():GetSpecialValueFor( "lightning_remnant_damage" )
	local delay = self:GetAbility():GetSpecialValueFor( "lightning_remnant_delay" )

	if not IsServer() then return end
	-- ability properties
	self.abilityDamageType = self:GetAbility():GetAbilityDamageType()

	self.tick = 0.1
	self.team = self.caster:GetTeamNumber()
	self.origin = self.parent:GetOrigin()

	self.damageTable = {
		attacker = self.caster,
		damage = damage,
		damage_type = self.abilityDamageType,
		ability = self:GetAbility(),
	}

	self:StartIntervalThink( delay )

	self:PlayEffects()
end

function modifier_lightning_remnant_thinker:OnDestroy()
	if not IsServer() then return end
	local enemies = FindUnitsInRadius(
		self.team,
		self.parent:GetOrigin(),	
		nil,	
		self.radius,	
		DOTA_UNIT_TARGET_TEAM_ENEMY,	
		DOTA_UNIT_TARGET_HERO,	
		0,	
		0,
		false
	)
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage(self.damageTable)
	end
	local sound_cast = "Hero_StormSpirit.StaticRemnantExplode"
	EmitSoundOn( sound_cast, self.parent )
	UTIL_Remove( self.parent )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_lightning_remnant_thinker:OnIntervalThink()
	if not self.active then
		self.active = true
		self:StartIntervalThink( self.tick )
	end

	local enemies = FindUnitsInRadius(
		self.team,	-- int, your team number
		self.origin,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.trigger,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	if #enemies>0 then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_lightning_remnant_thinker:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf"
	local sound_cast = "Hero_StormSpirit.StaticRemnantPlant"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, self.caster:GetForwardVector() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self.caster,
		PATTACH_POINT,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( ACT_DOTA_CAST_ABILITY_1, 1, 0 ) )
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
	EmitSoundOn( sound_cast, self.parent )
end