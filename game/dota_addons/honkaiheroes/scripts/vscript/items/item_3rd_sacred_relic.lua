LinkLuaModifier( "modifier_3rd_relic_passive", "items/item_3rd_sacred_relic", LUA_MODIFIER_MOTION_NONE )

item_rd_sacred_relic = class({})

function item_rd_sacred_relic:GetIntrinsicModifierName()
	return "modifier_3rd_relic_passive"
end

modifier_3rd_relic_passive = class({})

function modifier_3rd_relic_passive:IsHidden()
	return true
end

function modifier_3rd_relic_passive:OnCreated()
	ability = self:GetAbility()
	self.combocount1 = ability:GetLevelSpecialValueFor("combocount", 0)
	self.combocount2 = ability:GetLevelSpecialValueFor("combocount", 1)
	self.combocount3 = ability:GetLevelSpecialValueFor("combocount", 2)
	self.phys_bonus1 = ability:GetLevelSpecialValueFor("phys_bonus", 0)
	self.phys_bonus2 = ability:GetLevelSpecialValueFor("phys_bonus", 1)
	self.phys_bonus3 = ability:GetLevelSpecialValueFor("phys_bonus", 2)
	self.burst_mode_bonus = ability:GetSpecialValueFor("burst_mode_bonus")
end

function modifier_3rd_relic_passive:GetModifierBonusStats_PhysicalDamage()
	local owner = self:GetParent()
	local res = 0
	local combo_c = owner.combo_hit:GetStackCount()
	if combo_c>self.combocount3 then
		res = res + self.phys_bonus3
	else
		if combo_c > self.combocount2 then
			res = res + self.phys_bonus2
		else
			if combo_c > self.combocount1 then
				res = res + self.phys_bonus1
			end
		end
	end
	if owner:FindModifierByName("modifier_burst_mode"):IsActive() then
		res = res+self.burst_mode_bonus
	end
	return res
end

function modifier_3rd_relic_passive:DeclareFunctions()
	return {}
end