
overshield_modifier = class({})

function overshield_modifier:OnCreated(kv)
	self.value = kv.ammount
	self.element = kv.element
	DeepPrint(kv)
end

function overshield_modifier:OnRefresh(kv)
	if kv.replace then
		self.value = kv.ammount
	else
		self.value = kv.ammount + self.value
	end
end

function overshield_modifier:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT ,
		MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT  
	}
end

function overshield_modifier:GetModifierIncomingPhysicalDamageConstant(event)
	if event.damage > self.value then
		local ret = self.value
		self:Destroy()
		return -ret
	end
	self.value = self.value - event.damage
	return -event.damage
end

function overshield_modifier:GetModifierIncomingSpellDamageConstant(event)
	if event.damage > self.value then
		local ret = self.value
		self:Destroy()
		return -ret
	end
	self.value = self.value - event.damage
	return -event.damage
end


