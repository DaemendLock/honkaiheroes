LinkLuaModifier( "modifier_hot_dragon_passive", "herrschers/herrscher_of_thunder/dragon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hot_stun", "herrschers/herrscher_of_thunder/dragon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hot_breath", "herrschers/herrscher_of_thunder/dragon", LUA_MODIFIER_MOTION_NONE )

hot_dragon_stun = class({})

function hot_dragon_stun:OnChannelFinish(failed)
	if failed then
		self:GetCaster():MoveToTargetToAttack(self:GetCaster().target)
		return
	end
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local angle = self:GetSpecialValueFor("angle")/2
	local duration = self:GetSpecialValueFor("stun_duration")
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	local origin = caster:GetOrigin()
	local cast_angle = VectorToAngles( -caster:GetForwardVector() ).y
	for _,enemy in pairs(enemies) do
		
		local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
		local enemy_angle = VectorToAngles( enemy_direction ).y
		local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )
		if angle_diff<=angle then
			caster:PerformAttack(
				enemy,
				true,
				true,
				true,
				true,
				true,
				false,
				true
			)
			enemy:AddNewModifier(
				caster,
				self,
				"modifier_hot_stun",
				{
					duration = duration
				} 
			)
		end
	end
	self:GetCaster():MoveToTargetToAttack(self:GetCaster().target)
end

modifier_hot_stun = class({})

function modifier_hot_stun:IsHidden()
	return false
end

function modifier_hot_stun:IsDebuff()
	return true
end

function modifier_hot_stun:IsStunDebuff()
	return true
end

function modifier_hot_stun:IsPurgable()
	return true
end

function modifier_hot_stun:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}

	
end

hot_dragon_breath = class({})

function hot_dragon_breath:OnChannelFinish(failed)
	if failed then
		self:GetCaster():MoveToTargetToAttack(self:GetCaster().target)
		return
	end
	if not self:GetCaster().target then
		return
	end
	local caster = self:GetCaster()
	local point = caster.target:GetOrigin()
	local projectile_name = "particles/econ/items/drow/drow_arcana/drow_arcana_multishot_linear_proj_frost_v2.vpcf"
	local projectile_speed = 1000
	local projectile_distance = 1000
	local projectile_radius = self:GetSpecialValueFor("shot_radius")
	local projectile_direction = point-caster:GetOrigin()
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()
	if projectile_direction == Vector(0,0,0) then
		projectile_direction = Vector(-1 ,-1,0)
	end
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_radius,
	    fEndRadius = projectile_radius,
		vVelocity = projectile_direction * projectile_speed,
		bDrawsOnMinimap = true,	
	}
	local projectile = ProjectileManager:CreateLinearProjectile(info)

	local sound_cast = "Ability.Powershot"
	EmitSoundOn( sound_cast, caster )
	self:GetCaster():MoveToTargetToAttack(self:GetCaster().target)
end

function hot_dragon_breath:OnProjectileHit( target, location)
	if not IsServer() then return end
	if not target then
		return true
	end
	local damageTable = {
		attacker = self:GetCaster(),
		damage_type = 4,
		ability = self, 
		victim = target,
		damage = self:GetAbilityDamage()
	}
	target:AddNewModifier(self:GetCaster(), self, "modifier_hot_breath", {duration = self:GetSpecialValueFor("shot_breach_duration")})
	ApplyDamage(damageTable)
	EmitSoundOn("Hero_Zuus.GodsWrath.Target", target)
	return false
end

modifier_hot_breath = class({})

function modifier_hot_breath:OnCreated()
	if not IsServer() then return end
	self.shot_breach = self:GetAbility():GetSpecialValueFor("shot_breach")
	self:SetStackCount(1)
end

function modifier_hot_breath:OnRefresh()
	if not IsServer() then return end
	self:IncrementStackCount()
end

function modifier_hot_breath:DeclareFunctions()
	return {}
end

function modifier_hot_breath:GetModifierBreach_LightningDamage()
	return self.shot_breach*self:GetStackCount()
end

hot_dragon_passive = class({})

function hot_dragon_passive:GetIntrinsicModifierName()
	return "modifier_hot_dragon_passive"
end

modifier_hot_dragon_passive = class({})

function modifier_hot_dragon_passive:GetStatusEffectName()
	return "particles/status_fx/status_effect_bloodrage.vpcf"
end

function modifier_hot_dragon_passive:StatusEffectPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA 
end
