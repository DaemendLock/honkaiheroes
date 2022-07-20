item_key_of_devouring = class({})
LinkLuaModifier( "modifier_item_key_of_devouring_debuff", "keys/item_key_of_devouring", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_item_key_of_devouring_thinker", "keys/item_key_of_devouring", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_honkai_debuff", "honkai/modifier_honkai_debuff", LUA_MODIFIER_MOTION_NONE )	
LinkLuaModifier( "modifier_honkai_penalti", "honkai/modifier_honkai_penalti", LUA_MODIFIER_MOTION_NONE )	

function item_key_of_devouring:Precache( context )
	PrecacheResource( "soundfile", "soundevents/keys_sounds.vsndevts", context )  
	PrecacheResource( "particle",  "particles/units/heroes/hero_enigma/enigma_blackhole.vpcf", context)
end

function item_key_of_devouring:OnSpellStart()
	local caster = self:GetCaster()
	--EmitSoundOn("Hero_Silencer.GlobalSilence.Effect", caster)
	EmitGlobalSound("Honkaiheroes.StarOfEden.Cast")
	local point = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	local honka = caster:FindModifierByName("modifier_honkai_penalti")
	local honkaEnt = honka:GetCaster()
	
	caster:AddNewModifier(honkaEnt,
						  honka:GetAbility(),
						  "modifier_honkai_debuff",
						  {extra_stack = self:GetSpecialValueFor("apply_stacks")}
						  )
	self.thinker = CreateModifierThinker(
		caster,
		self,
		"modifier_item_key_of_devouring_thinker",
		{ duration = duration },
		point,
		caster:GetTeamNumber(),
		false
	)
	self.thinker = self.thinker:FindModifierByName("modifier_item_key_of_devouring_thinker")
end

--------------blackhole----------------------------------------------------------------------

modifier_item_key_of_devouring_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_item_key_of_devouring_thinker:IsHidden()
	return false
end

function modifier_item_key_of_devouring_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_item_key_of_devouring_thinker:OnCreated( kv )
	-- references
	self.far_radius = self:GetAbility():GetSpecialValueFor( "far_radius" )
	self.near_radius = self:GetAbility():GetSpecialValueFor( "near_radius" )
	self.interval = 1
	self.ticks = math.floor(self:GetDuration()/self.interval+0.5) -- round
	self.tick = 0

	if IsServer() then
		-- precache damage
		local damage = self:GetAbility():GetSpecialValueFor( "far_damage" )
		self.damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self:GetAbility(),
		}
		self:StartIntervalThink( self.interval )
		self:PlayEffects()
		self.damageTable2 = {
			attacker = self:GetCaster(),
			damage = self:GetAbility():GetSpecialValueFor( "near_damage" ),
			damage_type = DAMAGE_TYPE_PURE,
			ability = self:GetAbility(),
		}
		self:StartIntervalThink( self.interval )
	end
end

function modifier_item_key_of_devouring_thinker:OnRefresh( kv )
	
end

function modifier_item_key_of_devouring_thinker:OnRemoved()
	if IsServer() then
		-- ensure last tick damage happens
		if self:GetRemainingTime()<0.01 and self.tick<self.ticks then
			self:OnIntervalThink()
		end

		UTIL_Remove( self:GetParent() )
	end

	local sound_cast = "Hero_Enigma.Black_Hole"
	local sound_stop = "Hero_Enigma.Black_Hole.Stop"
	StopSoundOn( sound_cast, self:GetParent() )
	EmitSoundOn( sound_stop, self:GetParent() )
end

function modifier_item_key_of_devouring_thinker:OnDestroy()
	if IsServer() then
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_item_key_of_devouring_thinker:OnIntervalThink()
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetParent():GetOrigin(),
		nil,
		self.far_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		0,
		false
	)
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end
	enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetParent():GetOrigin(),
		nil,
		self.near_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		0,
		false
	)
	for _,enemy in pairs(enemies) do
		self.damageTable2.victim = enemy
		ApplyDamage( self.damageTable2 )
		
	end
	-- tick
	self.tick = self.tick+1
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_item_key_of_devouring_thinker:IsAura()
	return true
end

function modifier_item_key_of_devouring_thinker:GetModifierAura()
	return "modifier_item_key_of_devouring_debuff"
end

function modifier_item_key_of_devouring_thinker:GetAuraRadius()
	return self.far_radius
end

function modifier_item_key_of_devouring_thinker:GetAuraDuration()
	return 0.1
end

function modifier_item_key_of_devouring_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_key_of_devouring_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_item_key_of_devouring_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_item_key_of_devouring_thinker:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_enigma/enigma_blackhole.vpcf"
	local sound_cast = "Hero_Enigma.Black_Hole"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 60, Vector( 170,0,10) )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector( 170,0,10) )
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)
	particle_cast = "particles/units/heroes/hero_enigma/enigma_midnight_pulse.vpcf"
	effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.far_radius, 0, 0 ) )
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
	EmitSoundOn( sound_cast, self:GetParent() )
	EmitSoundOn( "honkaiheroes.StarOfEden.Activate", self:GetParent() )
end





------------------------------------------------------
modifier_item_key_of_devouring_debuff = class({})

function modifier_item_key_of_devouring_debuff:IsHidden()
	return false
end

function modifier_item_key_of_devouring_debuff:IsDebuff()
	return true
end

function modifier_item_key_of_devouring_debuff:IsStunDebuff()
	return true
end

function modifier_item_key_of_devouring_debuff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_item_key_of_devouring_debuff:OnCreated( kv )
	self.rate = self:GetAbility():GetSpecialValueFor( "animation_rate" )
	self.pull_speed = self:GetAbility():GetSpecialValueFor( "pull_speed" )
	self.rotate_speed = self:GetAbility():GetSpecialValueFor( "pull_rotate_speed" )
	if IsServer() then
		self.center = Vector( kv.aura_origin_x, kv.aura_origin_y, 0 )
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
		end
	end
end

function modifier_item_key_of_devouring_debuff:OnRefresh( kv )
	
end

function modifier_item_key_of_devouring_debuff:OnRemoved()
end

function modifier_item_key_of_devouring_debuff:OnDestroy()
	if IsServer() then
		-- motion compulsory interrupts
		self:GetParent():InterruptMotionControllers( true )
	end
end

function modifier_item_key_of_devouring_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}

	return funcs
end

function modifier_item_key_of_devouring_debuff:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_item_key_of_devouring_debuff:GetOverrideAnimationRate()
	return self.rate
end

function modifier_item_key_of_devouring_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

function modifier_item_key_of_devouring_debuff:UpdateHorizontalMotion( me, dt )
	local target = self:GetParent():GetOrigin()-self.center
	target.z = 0
	local targetL = target:Length2D()-self.pull_speed*dt
	local targetN = target:Normalized()
	local deg = math.atan2( targetN.y, targetN.x )
	local targetN = Vector( math.cos(deg+self.rotate_speed*dt), math.sin(deg+self.rotate_speed*dt), 0 );

	self:GetParent():SetOrigin( self.center + targetN * targetL )


end

function modifier_item_key_of_devouring_debuff:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_item_key_of_devouring_debuff:OnHorizontalMotionInterrupted()
	self:Destroy()
end
