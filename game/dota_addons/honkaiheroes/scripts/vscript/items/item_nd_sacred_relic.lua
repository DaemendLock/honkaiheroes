LinkLuaModifier( "modifier_nd_relic_passive", "items/item_nd_sacred_relic", LUA_MODIFIER_MOTION_NONE )

item_nd_sacred_relic = class({})

function item_nd_sacred_relic:GetIntrinsicModifierName()
	return "modifier_nd_relic_passive"
end

modifier_nd_relic_passive = class({})

function modifier_nd_relic_passive:IsHidden()
	return true
end
function modifier_nd_relic_passive:OnCreated()
	self.mana_reg_pct = self:GetAbility():GetSpecialValueFor("mana_reg_pct")/100
	self.mana_per_stack = self:GetAbility():GetSpecialValueFor("mana_per_stack")
	self.crt_damage = self:GetAbility():GetSpecialValueFor("crt_damage")
	self.damageT = {
		damage = self:GetAbility():GetSpecialValueFor("proc_dmg"),
		attacker = self:GetParent(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self
	}
end

function modifier_nd_relic_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL
	}
end

function modifier_nd_relic_passive:GetModifierTotalPercentageManaRegen()
	return self.mana_reg_pct
end

function modifier_nd_relic_passive:GetModifierBonusStat_CritDamage()
	return min((self:GetParent():GetMana()/self.mana_per_stack)%1, 8)*self.crt_damage
end

function modifier_nd_relic_passive:GetModifierProcAttack_BonusDamage_Magical(event)
	if event.attacker == self:GetParent() and event.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
		self.damageT.victim = event.target
		ApplyDamage(self.damageT)
	end
	return 0
end



