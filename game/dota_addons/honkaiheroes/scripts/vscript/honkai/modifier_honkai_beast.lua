LinkLuaModifier( "modifier_honkai_debuff", "honkai/modifier_honkai_debuff", LUA_MODIFIER_MOTION_NONE )	
LinkLuaModifier( "modifier_honkai_penalti", "honkai/modifier_honkai_penalti", LUA_MODIFIER_MOTION_NONE )

modifier_honkai_beast= class({})

--------------------------------------------------------------------------------

function modifier_honkai_beast:IsHidden()
	return false
end

function modifier_honkai_beast:IsDebuff()
	return true
end

function modifier_honkai_beast:IsPurgable()
	return false
end
--------------------------------------------------------------------------------

function modifier_honkai_beast:OnCreated( kv )
	-- references
	self.armor_bonus = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "bonus_movement_speed" )
	self.damage_pct = self:GetAbility():GetSpecialValueFor( "damage" )
	self.debuff_chc = self:GetAbility():GetSpecialValueFor("debuff_chc")
	self.hp_pct = self:GetAbility():GetSpecialValueFor("hp_pct")
	self.hps = self:GetAbility():GetSpecialValueFor("hps")
	if not IsServer() then return end
end

function modifier_honkai_beast:OnRefresh( kv )
end


function modifier_honkai_beast:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE ,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
		
	}

	return funcs
end

function modifier_honkai_beast:GetModifierPreAttack_BonusDamage()
	return self.damage_pct
end

function modifier_honkai_beast:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end

function modifier_honkai_beast:GetModifierPhysicalArmorBonus()
	return self.armor_bonus
end

function modifier_honkai_beast:GetModifierModelScale()
	return 100
end

function modifier_honkai_beast:OnAttackLanded(kv)
	if not IsServer() then return end
	if kv.attacker == self:GetParent() and kv.fail_type == 0  and RollPercentage(self.debuff_chc) then
		kv.target:AddNewModifier(self:GetCaster(),
						  self:GetCaster():GetAbilityByIndex(0),
						  "modifier_honkai_debuff",
						  {extra_stack = 1}
						  )
	end
end

function modifier_honkai_beast:GetModifierConstantHealthRegen()
	return self.hps
end

function modifier_honkai_beast:GetModifierExtraHealthPercentage()
	return self.hp_pct
end

function modifier_honkai_beast:GetModifierDamageOutgoing_Percentage()
	return 100
end
