if modifier_burst_mode == nil then
	modifier_burst_mode = class({})
end

function modifier_burst_mode:IsHidden() return true end

function modifier_burst_mode:IsActive()
	local buffs = self:GetParent():FindAllModifiers()
	for _, buff in pairs(buffs) do
		if buff:GetCaster() == self:GetParent() and buff:GetAbility() ~= nil and buff:GetAbility():GetAbilityKeyValues().ConsideredBurstmode ~= nil and buff:GetDuration()>0 then
			return true
		end
	end
	return false
end
