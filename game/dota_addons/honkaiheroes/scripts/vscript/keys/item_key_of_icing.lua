LinkLuaModifier( "modifier_freeze_sequence", "keys/item_key_of_icing", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_freeze_passive", "keys/item_key_of_icing", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_freeze_first", "keys/item_key_of_icing", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_freeze_second", "keys/item_key_of_icing", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_freeze_third", "keys/item_key_of_icing", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_honkai_debuff", "honkai/modifier_honkai_debuff", LUA_MODIFIER_MOTION_NONE )	

item_key_of_icing = class({})

function item_key_of_icing:GetIntrinsicModifierName()
	return "modifier_freeze_passive"
end

item_key_of_icing.sounds = {[1] = "Honkaiheroes.Skadi.Cast1", [2] = "Honkaiheroes.Skadi.Cast2", [3] = "Honkaiheroes.Skadi.Cast3",[4] = "Honkaiheroes.Skadi.Cast1",}
item_key_of_icing.casttime = {[0] = 0.15, [1] = 0.15, [2] = 0.6, [3] = 1,[4] = 0.15,}
item_key_of_icing.phase = 1

function item_key_of_icing:GetCastPointModifier()
	print(IsServer(), item_key_of_icing.casttime[self.phase])
	return item_key_of_icing.casttime[self.phase]
end

function item_key_of_icing:OnAbilityPhaseStart()
	EmitSoundOn(item_key_of_icing.sounds[self.phase], self:GetCaster())
	self:GetCaster():StartGesture(ACT_DOTA_ATTACK)
	return true
end

function item_key_of_icing:OnAbilityPhaseInterrupted()
	StopSoundOn(item_key_of_icing.sounds[self.phase], self:GetCaster())
end

function item_key_of_icing:OnSpellStart()
	local time_diff = self:GetSpecialValueFor("time_diff")
	local i = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_freeze_sequence", {duration = time_diff}):GetStackCount()
	self.phase = i%3+1
	
	if i == 1 then
		self:FirstHit()
	else
		if i == 2 then
			self:SecondHit()
		else 
			self:ThirdHit()
		end
	end
	self:SetOverrideCastPoint(item_key_of_icing.casttime[self.phase])
	self.mod:SetDuration(self:GetSpecialValueFor("charge_cd"), true)
	self.mod:SetStackCount(self:GetCurrentAbilityCharges())
	local honka = self:GetCaster():FindModifierByName("modifier_honkai_penalti")
	local honkaEnt = honka:GetCaster()
	self:GetCaster():AddNewModifier(honkaEnt,
						  honka:GetAbility(),
						  "modifier_honkai_debuff",
						  {extra_stack = self:GetSpecialValueFor("apply_stacks")}
						  )
end

function item_key_of_icing:FirstHit()
	EmitSoundOn("", self:GetCaster())
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("first_radius")
	local trauma_duration = self:GetSpecialValueFor( "trauma_duration" )
	local damage = self:GetSpecialValueFor("damage")/100
	local angle =  self:GetSpecialValueFor("angle")/2
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster:GetOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		0,
		false
	)
	local origin = caster:GetOrigin()
	local cast_direction = (point-origin):Normalized()
	local cast_angle = VectorToAngles( cast_direction ).y
	local damageT = {
					attacker = caster,
					damage = damage*caster:GetAttackDamage(),
					damage_type = self:GetAbilityDamageType(),
					ability = self,
					damage_flags = 0
					}
	for _,enemy in pairs(enemies) do
		local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
		local enemy_angle = VectorToAngles( enemy_direction ).y
		local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )
		if angle_diff<=angle then
			enemy:AddNewModifier(caster, self, "modifier_freeze_first", {duration = trauma_duration})
			damageT.victim = enemy
			ApplyDamage(damageT)
		end
	end
	self:PlayEffect1( cast_direction )
	
end

function item_key_of_icing:SecondHit()
	local caster = self:GetCaster()
	local point =  self:GetCursorPosition()
	local origin = caster:GetOrigin()
	local radius = self:GetSpecialValueFor( "second_radius" )
	local trauma_duration = self:GetSpecialValueFor( "trauma_duration" )
	local damage = self:GetSpecialValueFor("damage")/100
	local cast_direction = (point-origin):Normalized()
	local damageT = {
					attacker = caster,
					damage = damage*caster:GetAttackDamage(),
					damage_type = self:GetAbilityDamageType(),
					ability = self,
					damage_flags = 0
					}
	local enemies = FindUnitsInLine(
		caster:GetTeamNumber(),
		caster:GetOrigin(),
		caster:GetOrigin()+cast_direction*radius,
		self:GetCaster(),
		100,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	)
	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(caster, self, "modifier_freeze_second", {duration = trauma_duration})
		damageT.victim = enemy
		ApplyDamage(damageT)
	end
	self:PlayEffect2( cast_direction )
end

function item_key_of_icing:ThirdHit()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor( "third_radius" )
	local trauma_duration = self:GetSpecialValueFor( "trauma_duration" )
	local damage = self:GetSpecialValueFor("damage")/100
	local damageT = {
					attacker = caster,
					damage = damage*caster:GetAttackDamage(),
					damage_type = self:GetAbilityDamageType(),
					ability = self,
					damage_flags = 0
					}
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster:GetOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		0,
		false
	)
	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(caster, self, "modifier_freeze_third", {duration = trauma_duration})
		damageT.victim = enemy
		ApplyDamage(damageT)
	end
	self:PlayEffect3()
end
--EFFECTS--STAFF-----------------------------

function item_key_of_icing:PlayEffect1( direction )
	local particle_cast = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_arcana_swoop_a.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetCaster():GetOrigin()+direction*2  )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector(-3,-3,1))
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function item_key_of_icing:PlayEffect2( direction )
	local particle_cast = "particles/econ/items/jakiro/jakiro_ti7_immortal_head/jakiro_ti7_immortal_head_ice_path_ice.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetCaster():GetOrigin()+ direction*self:GetSpecialValueFor( "second_radius" ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	local particle_cast = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_arcana_swoop_a.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetCaster():GetOrigin()+direction*2  )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector(-1,-1,1))
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function item_key_of_icing:PlayEffect3( )
	local particle_cast = "particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_explode.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 3, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 60, Vector(50, 255 , 255))
	ParticleManager:SetParticleControl( effect_cast, 61, Vector(255,255,255))
	ParticleManager:ReleaseParticleIndex( effect_cast )
	self:GetCaster():StartGesture(ACT_DOTA_ATTACK_EVENT  )
	 
end


--MODIFIERS-----------------------------------------------------------------------------

modifier_freeze_sequence = class({})

function modifier_freeze_sequence:OnCreated()
	self:SetStackCount(1)
end

function modifier_freeze_sequence:OnRefresh()
	if not IsServer() then return end
	self:IncrementStackCount()
	if self:GetStackCount() == 4 then
		self:SetStackCount(1)
	end
	
end	

function modifier_freeze_sequence:OnDestroy()
	self:GetAbility().phase = 1
	if IsServer() then
	self:GetAbility():SetOverrideCastPoint(item_key_of_icing.casttime[self:GetAbility().phase])
	end
	if self:GetParent().GetCurrentActiveAbility and self:GetParent():GetCurrentActiveAbility() == self:GetAbility() then self:GetCaster():Interrupt() end
end


modifier_freeze_passive = class({})

function modifier_freeze_passive:DestroyOnExpire()
	self:SetDuration(0, true)
	return false
end

function modifier_freeze_passive:OnCreated()
	self:GetAbility().mod = self
	self:SetStackCount(self:GetAbility():GetCurrentAbilityCharges())
	self.ice_bonus = self:GetAbility():GetSpecialValueFor("ice_bonus")
	self.total_bonus = self:GetAbility():GetSpecialValueFor("total_bonus")
end

function modifier_freeze_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE 
	}
end

function modifier_freeze_passive:GetModifierTotalDamageOutgoing_Percentage(event)
	if event.target:IsHero() and event.target:GetPrimaryAttribute() == DOTA_ATTRIBUTE_STRENGTH then
	return self.total_bonus
	end
	return 0
end

function modifier_freeze_passive:GetModifierBonusStats_IceDamage()
	return self.ice_bonus
end


modifier_freeze_first = class({})

function modifier_freeze_first:GetStatusEffectName()
	return "particles/status_fx/status_effect_wyvern_arctic_burn.vpcf"
end

function modifier_freeze_first:OnCreated()
	
	self.speed_bonus = self:GetAbility():GetSpecialValueFor("speed_bonus")
end

function modifier_freeze_first:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
			MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE }
end

function modifier_freeze_first:GetModifierMoveSpeedBonus_Percentage()
	return self.speed_bonus
end

function modifier_freeze_first:GetModifierAttackSpeedPercentage()
	return self.speed_bonus
end


modifier_freeze_second = class({})

function modifier_freeze_second:GetDisableHealing()
	return 1
end

function modifier_freeze_second:GetStatusEffectName()
	return "particles/status_fx/status_effect_iceblast.vpcf"
end

function modifier_freeze_second:DeclareFunctions()
	return {MODIFIER_PROPERTY_DISABLE_HEALING  }
end



modifier_freeze_third = class({})

function modifier_freeze_third:IsPurgable()
	return false
end

function modifier_freeze_third:CheckState()
	return 
	{
	[MODIFIER_STATE_FROZEN  ]=true,
	[MODIFIER_STATE_ROOTED]=true,
	[MODIFIER_STATE_STUNNED  ]=true,
	[MODIFIER_STATE_EVADE_DISABLED ]=true,
	[MODIFIER_STATE_SILENCED]=true
	}
end

function modifier_freeze_third:GetStatusEffectName()
	return "particles/status_fx/status_effect_wyvern_curse_target.vpcf"
end

function modifier_freeze_third:GetEffectName()
	return "particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_buff.vpcf"
end
