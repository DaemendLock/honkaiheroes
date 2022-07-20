LinkLuaModifier( "modifier_aggro_counter", "herrschers/aggro.lua", LUA_MODIFIER_MOTION_NONE )

aggro_passive = class({})

function aggro_passive:GetIntrinsicModifierName()
	return "modifier_aggro_counter"
end

modifier_aggro_counter = class({})

function modifier_aggro_counter:OnCreated()
	self:GetParent().aggroList = {}
	self.max = 0
end

function modifier_aggro_counter:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE 
	}
end

function modifier_aggro_counter:GetModifierIncomingDamage_Percentage(event)
	local id = event.attacker:GetEntityIndex()
	if(not self:GetParent().aggroList[id]) then
		self:GetParent().aggroList[id] = 0
	end
	if event.attacker.aggroBonus then
		self:GetParent().aggroList[id] = self:GetParent().aggroList[id] + event.damage*event.attacker.aggroBonus
	
	else
		self:GetParent().aggroList[id] = self:GetParent().aggroList[id] + event.damage
	end
	if self.max < self:GetParent().aggroList[id] then
		self.max = self:GetParent().aggroList[id]*1.3
		self:GetParent().target = event.attacker
		self:GetParent():SetAttacking(event.attacker)
		self:GetParent():MoveToTargetToAttack(event.attacker)
	end
	return 0
end