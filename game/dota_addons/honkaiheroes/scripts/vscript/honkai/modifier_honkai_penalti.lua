LinkLuaModifier("modifier_honkai_beast","honkai/modifier_honkai_beast",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_burst_mode","honkai/modifier_burst_mode",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hit_combo","honkai/modifier_hit_combo",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_honkai_penalti","honkai/modifier_honkai_penalti",LUA_MODIFIER_MOTION_NONE)

modifier_honkai_penalti = class({})

--------------------------------------------------------------------------------

function modifier_honkai_penalti:IsHidden()
	return true
end
function modifier_honkai_penalti:GetModifierAura()
	return "modifier_honkai_penalti"
end
function modifier_honkai_penalti:IsDebuff()
	return true
end

function modifier_honkai_penalti:IsAura()
	return true
end

function modifier_honkai_penalti:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH + DOTA_UNIT_TARGET_TEAM_CUSTOM 
end

function modifier_honkai_penalti:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_honkai_penalti:GetAuraRadius()
	return self.aura_radius
end

function modifier_honkai_penalti:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_honkai_penalti:IsPurgable()
	return false
end

function modifier_honkai_penalti:RemoveOnDeath()
	return false
end


--------------------------------------------------------------------------------

function modifier_honkai_penalti:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
	if not IsServer() then return end
	local unit = self:GetParent()
	unit:AddNewModifier(unit, self:GetAbility(), "modifier_burst_mode", {})
	if unit == self:GetCaster() then
	return
	end
	
	if unit:IsCreep() and not unit:IsCreepHero() and unit:IsNeutralUnitType()then
		if RollPercentage(100) then
			unit:AddNewModifier(self:GetCaster(), self:GetCaster():GetAbilityByIndex(2), "modifier_honkai_beast", {})
			unit:SetOwner(self:GetCaster())
		end
	else
		unit:AddNewModifier(unit, nil, "modifier_hit_combo", {hits = 0, duration = 7})
	end
end

function modifier_honkai_penalti:OnRefresh( kv )
end

