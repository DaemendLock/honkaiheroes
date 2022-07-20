LinkLuaModifier( "modifier_item_key_of_sentience_sleep", "keys/item_key_of_sentience", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_key_of_sentience_buff", "keys/item_key_of_sentience", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_key_of_sentience_dust", "keys/item_key_of_sentience", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_key_of_sentience_leaved", "keys/item_key_of_sentience", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_flamingheart_aura", "keys/phoenix_down_abilities", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_flamingheart_aura_effect", "keys/phoenix_down_abilities", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_memory_sacrifice", "keys/phoenix_down_abilities", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_combo_attack", "keys/phoenix_down_abilities", LUA_MODIFIER_MOTION_NONE )

retrix = class({})
cinder = class({})
featherdown = class({})
flamingheart = class({})
rainbowpinion = class({})
flamegust = class({})	

function retrix:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	local damageT = {
					attacker = caster,
					victim = target,
					damage = self:GetAbilityDamage(),
					damage_type = self:GetAbilityDamageType(),
					ability = self,
					damage_flags = DOTA_DAMAGE_FLAG_IGNORES_MAGIC_ARMOR
					}
	ApplyDamage(damageT)
end


function featherdown:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	if target:GetTeam() ~= caster:GetTeam() then
		target:AddNewModifier(caster, self, "modifier_item_key_of_sentience_sleep", {duration = self:GetSpecialValueFor("sleep_duration")})
		self:StartCooldown(self:GetSpecialValueFor("sleep_cd"))
	else
		local owner = caster:GetOwner()
		if target ~= owner and target ~= caster then
			target:AddNewModifier(caster, self, "modifier_item_key_of_sentience_buff", {duration = self:GetSpecialValueFor("buff_duration")})
			target:AddNewModifier(caster, self, "modifier_item_key_of_sentience_dust", {duration = self:GetSpecialValueFor("buff_duration")})
			self:StartCooldown(self:GetSpecialValueFor("buff_cd"))
		else
			owner:FindModifierByNameAndCaster("modifier_item_key_of_sentience_leaved", owner)
		end
	end
	
end

function flamingheart:GetIntrinsicModifierName()
	return "modifier_flamingheart_aura"
end

modifier_flamingheart_aura = class({})

function modifier_flamingheart_aura:OnCreated( kv )
	--self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.radius = 1200
	self.hp = self:GetAbility():GetSpecialValueFor( "hp_per_level" )
	self.mana = self:GetAbility():GetSpecialValueFor( "mana_per_level" )
end

function modifier_flamingheart_aura:GetStatusEffectName() return "particles/status_fx/status_effect_life_stealer_rage.vpcf" end
function modifier_flamingheart_aura:GetHeroEffectName() return "particles/econ/items/alchemist/alchemist_aurelian_weapon/alchemist_chemical_rage_glow_aurelian.vpcf" end


function modifier_flamingheart_aura:IsHidden() return true end

function modifier_flamingheart_aura:IsDebuff() return false end

function modifier_flamingheart_aura:IsPurgable() return false end

function modifier_flamingheart_aura:IsAura() return true end

function modifier_flamingheart_aura:GetModifierAura() return "modifier_flamingheart_aura_effect" end

function modifier_flamingheart_aura:GetAuraRadius() return self.radius end

function modifier_flamingheart_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_flamingheart_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end

function modifier_flamingheart_aura:GetAuraSearchFlags() return 0 end

function modifier_flamingheart_aura:GetAuraDuration() return 0.5 end



function modifier_flamingheart_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS ,
		MODIFIER_PROPERTY_MANA_BONUS
	}
end

function modifier_flamingheart_aura:GetModifierExtraManaBonus() return self:GetParent():GetLevel()*self.mana end

function modifier_flamingheart_aura:GetModifierHealthBonus() return self:GetParent():GetLevel()*self.hp end

modifier_flamingheart_aura_effect = class({})

function modifier_flamingheart_aura_effect:IsHidden()
	return false
end

function modifier_flamingheart_aura_effect:IsDebuff()
	return false
end

function modifier_flamingheart_aura_effect:IsPurgable()
	return false
end

function modifier_flamingheart_aura_effect:OnCreated( kv )
	self.as_bonus = self:GetAbility():GetSpecialValueFor( "as_bonus_pct" )
end

function modifier_flamingheart_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE 
	}

	return funcs
end
function modifier_flamingheart_aura_effect:GetModifierAttackSpeedPercentage()
	return self.as_bonus
end

function cinder:GetIntrinsicModifierName()
	return "modifier_combo_attack"
end

function cinder:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local angle = self:GetSpecialValueFor("angle")/2
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
	local cast_direction = (point-origin):Normalized()
	local cast_angle = VectorToAngles( cast_direction ).y
	local damageT = {
					attacker = caster,
					damage = self:GetAbilityDamage(),
					damage_type = self:GetAbilityDamageType(),
					ability = self,
					damage_flags = DOTA_DAMAGE_FLAG_IGNORES_MAGIC_ARMOR
					}
	for _,enemy in pairs(enemies) do
		local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
		local enemy_angle = VectorToAngles( enemy_direction ).y
		local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )
		if angle_diff<=angle then
			damageT.victim = enemy
			ApplyDamage(damageT)
		end
	end

	self:PlayEffects( caught, (point-origin):Normalized() )
	
	--caster:AddNewModifier(caster, self, "modifier_combo_attack", {duration = 9, value = 2})
	if self.combo_attack_value == 112 then
		self:QQW(caster, enemies)
	elseif self.combo_attack_value == 1112 then
		self:QQQW(caster,enemies)
	elseif self.combo_attack_value == 11112 then
		self:QQQQW(caster)
	elseif self.combo_attack_value == 11212 then
		self:QQWQW()
	elseif self.combo_attack_value == 112112 then
		self:QQWQQW()
	elseif self.combo_attack_value == 1121122 then
		self:QQWQQWW()
	end
end


--COMBOS----COMBOS----COMBOS----COMBOS----COMBOS----COMBOS----COMBOS----COMBOS--

function cinder:QQW(caster, enemies)
	--breach
end

function cinder:QQQW(caster, enemies)
	--ignite+stun
end

function cinder:QQQQWWWW(caster)
	--better hit + mana restor
end

function cinder:QQQWR()
	--burst mode
end

function cinder:QQWQW(caster)
	--buff allies
end

function cinder:QQWQQW(caster)
	--mana+cd
	self:StartCooldown(0)
end

function cinder:QQWQQWW(caster)
	--buff field + busrt mode
end

modifier_combo_attack = class({})

function modifier_combo_attack:OnCreated()
	self:GetAbility().combo_attack_value = self
end

function modifier_combo_attack:OnDestroy()
	se
end

--------------------------------------------------------------------------------
-- Play Effects
function cinder:PlayEffects( caught, direction )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_mars/mars_shield_bash.vpcf"
	local sound_cast = "Hero_Mars.Shield.Cast"
	if not caught then
		local sound_cast = "Hero_Mars.Shield.Cast.Small"
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end


modifier_memory_sacrifice = class({})

function modifier_memory_sacrifice:OnCreated()
	self:SetStackCount(1)
end

function modifier_memory_sacrifice:OnRefresh()
	self:IncrementStackCount()
end

function modifier_memory_sacrifice:GetModifierBonusStats_Intellect()
	return -5*self:GetStackCount()
end

function modifier_memory_sacrifice:DeclareFunctions() 
	return{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS 
	}
end


