LinkLuaModifier( "modifier_mjolnir_gun_def", "items/item_mjolnir_gun", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mjolnir_gun_passive", "items/item_mjolnir_gun", LUA_MODIFIER_MOTION_NONE )

item_mjolnir_gun = class({})

function item_mjolnir_gun:GetIntrinsicModifierName()
	return "modifier_mjolnir_gun_passive"
end

function item_mjolnir_gun:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	ApplyDamage({
	attacker = caster,
	victim = target,
	damage = self:GetSpecialValueFor("atk_pct")*caster:GetAttackDamage()/100,
	damage_type = DAMAGE_TYPE_PHYSICAL,
	ability = self,
	})
	target:AddNewModifier(caster,self, "modifier_mjolnir_gun_def", {duration = self:GetDuration()})
	self:PlayEffects(target:GetOrigin())
	
end

function item_mjolnir_gun:PlayEffects( point)
	local particle_cast = "particles/items4_fx/meteor_hammer_spell_ground_impact.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 3, point )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

modifier_mjolnir_gun_passive = class({})

function modifier_mjolnir_gun_passive:IsHidden()
	return true
end
function modifier_mjolnir_gun_passive:OnCreated()
	self.crit_rate_pct = self:GetAbility():GetSpecialValueFor("crit_rate_pct")/100
end

function modifier_mjolnir_gun_passive:DeclareFunctions()
	return {
	}
end

function modifier_mjolnir_gun_passive:GetModifierBonusStat_CritRate()
	return self.crit_rate_pct
end

modifier_mjolnir_gun_def = class({})

function modifier_mjolnir_gun_def:OnCreated()
	self.armor_bonus = self:GetAbility():GetSpecialValueFor("armor_bonus_pct")*self:GetParent():GetPhysicalArmorValue(false)/100
end

function modifier_mjolnir_gun_def:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS 
	}
end	

function modifier_mjolnir_gun_def:GetModifierPhysicalArmorBonus()
	return self.armor_bonus
end
