LinkLuaModifier( "buff_nue_of_shadow", "items/item_nue_of_shadow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "nue_of_shadow_passive", "items/item_nue_of_shadow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "nue_of_shadow_dodge", "items/item_nue_of_shadow", LUA_MODIFIER_MOTION_NONE )

item_nue_of_shadow = class({})

function item_nue_of_shadow:GetIntrinsicModifierName()
	return "nue_of_shadow_passive"
end

nue_of_shadow_passive = class({})

function nue_of_shadow_passive:IsHidden()
	return true
end

function nue_of_shadow_passive:OnProjectileDodge(event)
	if event.target == self:GetParent() then 
		event.target:AddNewModifier(self:GetCaster(), self:GetAbility(),"nue_of_shadow_dodge", {duration = self:GetAbility():GetSpecialValueFor("duration")} )
	end
end

function nue_of_shadow_passive:DeclareFunctions()
	return {MODIFIER_EVENT_ON_PROJECTILE_DODGE }
end

nue_of_shadow_dodge = class({})

function nue_of_shadow_dodge:OnCreated()
	self.damage_res = self:GetAbility():GetSpecialValueFor("damage_res")
end

function nue_of_shadow_dodge:DeclareFunctions()
	return {}
end

function nue_of_shadow_dodge:GetModifierBreach_PhysicalDamage()
	return self.damage_res
end

function nue_of_shadow_dodge:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function item_nue_of_shadow:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	local origin = caster:GetOrigin()
	-- teleport
	self:PlayEffects(origin, point)
	local enemies = FindUnitsInLine(
		caster:GetTeamNumber(),	-- int, your team number
		origin,	-- point, start point
		point,	-- point, end point
		nil,	-- handle, cacheUnit. (not known)
		100,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES	-- int, flag filter
	)
	for _,enemy in pairs(enemies) do
		caster:PerformAttack( enemy, false, true, true, false, false, false, true )
	end
	ProjectileManager:ProjectileDodge(caster)
	FindClearSpaceForUnit( caster, point, true )
	local allies = FindUnitsInRadius(caster:GetTeam(), point, nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY , DOTA_UNIT_TARGET_HERO , 0, FIND_ANY_ORDER , false)
	for _, unit in pairs(allies) do
		unit:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"buff_nue_of_shadow", -- modifier name
			{ duration =  duration}
		)
	end
end

function item_nue_of_shadow:PlayEffects( origin, target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_beam.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControl( effect_cast, 2, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end



buff_nue_of_shadow = class({})

function buff_nue_of_shadow:OnCreated()
	self.critDmg = self:GetAbility():GetSpecialValueFor("crit_dmg_pct")
	self.critRate = self:GetAbility():GetSpecialValueFor("crit_rate_pct")
end

function buff_nue_of_shadow:DeclareFunctions()
	return {}
end

function buff_nue_of_shadow:GetModifierBonusStat_CritRate()
	return self.critRate
end

function buff_nue_of_shadow:GetModifierBonusStat_CritDamage()
	return self.critDmg
end



