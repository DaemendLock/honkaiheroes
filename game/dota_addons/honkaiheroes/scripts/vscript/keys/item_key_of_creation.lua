LinkLuaModifier( "modifier_honkai_debuff", "honkai/modifier_honkai_debuff", LUA_MODIFIER_MOTION_NONE )	
LinkLuaModifier( "modifier_honkai_penalti", "honkai/modifier_honkai_penalti", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_white_flower_buff", "keys/item_abyss_flower", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_key_of_creation", "keys/item_key_of_creation", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_black_abyss", "keys/item_abyss_flower", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_key_of_creation_passive", "keys/item_key_of_creation", LUA_MODIFIER_MOTION_NONE )

item_key_of_creation = class({})

function item_key_of_creation:GetIntrinsicModifierName() return "modifier_key_of_creation_passive" end

function item_key_of_creation:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function item_key_of_creation:OnSpellStart(event)
	
	--if not IsServer() then return end
	--if not self.success then return end

	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	if self:GetCursorTarget() == caster then
		self:EndCooldown()
		caster:RemoveItem(self)
		caster:AddItemByName("item_black_abyss")
		caster:AddItemByName("item_white_flower")
		return
	end
	local honka = caster:FindModifierByName("modifier_honkai_penalti")
	local honkaEnt = honka:GetCaster()
	local cTarget = self:GetCursorTarget()
	
	local vector = self:GetCursorPosition() - caster:GetOrigin()
	local projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
	local projectile_distance = vector:Length2D()
	local projectile_direction = vector
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_NONE,
	    fDistance = projectile_distance,
	    fStartRadius = 0,
	    fEndRadius = 0,
		vVelocity = projectile_direction * projectile_speed,
		EffectName = "particles/econ/items/drow/drow_arcana/drow_arcana_multishot_linear_proj_base.vpcf"
	}
	ProjectileManager:CreateLinearProjectile(info)
	caster:AddNewModifier(
		honkaEnt,
		honka:GetAbility(),
		"modifier_honkai_debuff",
		{extra_stack = self:GetSpecialValueFor("apply_stacks")})
	return true
end

function item_key_of_creation:OnProjectileHit( target, location )
	if target then return false end
	self:PlayEffects()
	local duration = self:GetSpecialValueFor( "duration" )
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor( "radius" )
	self.enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		location,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	self.teammates = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		location,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NONE, 	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	-- Apply Damage	 
	local damageTable = {
		attacker = caster,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self, --Optional.
	}
	local delay = self:GetSpecialValueFor("delay")
	CreateModifierThinker(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_item_key_of_creation", -- modifier name
		{ duration = delay }, -- kv
		location,
		self:GetCaster():GetTeamNumber(),
		false
	)

end

function item_key_of_creation:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_earthshaker/earthshaker_aftershock.vpcf"
	local sound_cast = "Hero_Leshrac.Split_Earth"

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self:	GetSpecialValueFor("radius"), 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end
---------------------exsplostion-----------
modifier_item_key_of_creation = class({})
function modifier_item_key_of_creation:OnRemoved()
	if not IsServer() then return end
	local duration = self:GetAbility():GetSpecialValueFor("duration")
	local caster = self:GetCaster()
	local heal = self:GetAbility():GetSpecialValueFor("heal")
	local damage = self:GetAbility():GetSpecialValueFor("damage")
	local damageTable = {
		attacker = caster,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self:GetAbility(), --Optional.
		damage = caster:GetAttackDamage()*damage/100
	}
	for _,mate in pairs(self:GetAbility().enemies) do
		damageTable.victim = mate
		ApplyDamage(damageTable)
		mate:AddNewModifier(caster, self, "modifier_black_abyss", {duration = duration})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE  , mate, caster:GetAttackDamage()*damage/100, caster:GetPlayerOwner())
	end
	for _,mate in pairs(self:GetAbility().teammates) do
		mate:HealWithParams(caster:GetAttackDamage()*heal/100, self:GetAbility(), false, true, caster, true)
		mate:AddNewModifier(caster, self:GetAbility(), "modifier_white_flower_buff", {duration = duration})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL , mate, caster:GetAttackDamage()*heal/100, caster:GetPlayerOwner())
	end
	self:PlayEffects(self:GetParent():GetOrigin())
end

function modifier_item_key_of_creation:PlayEffects(location)
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_treant/treant_overgrowth_cast.vpcf"
	local sound_cast = "Honkaiheroes.Skadi.Cast2"

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, location )
	ParticleManager:SetParticleControl( effect_cast, 60, Vector( 255,255,255) )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector( 255,255,255) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
	local particle_cast = "particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_ring.vpcf"

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetAbility():GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, location )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self:GetAbility():GetSpecialValueFor( "radius" ),0,0) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

modifier_key_of_creation_passive = class({})

function modifier_key_of_creation_passive:IsHidden() return true end

function modifier_key_of_creation_passive:DeclareFunctions()
	return {MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,}
end

function modifier_key_of_creation_passive:GetModifierPercentageCooldown(event)
	if event.ability.GetAbilityType and event.ability:GetAbilityType() == 1 then return self:GetAbility():GetSpecialValueFor("cd_red") end
	return 0
end

function modifier_key_of_creation_passive:GetModifierBonusStat_BurstmodeDamage()
	return self:GetAbility():GetSpecialValueFor("burst_buff")
end