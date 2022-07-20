modifier_honkai_debuff= class({})
--LinkLuaModifier( "modifier_honkai_penalti", "modifier_honkai_penalti", LUA_MODIFIER_MOTION_NONE )	
--------------------------------------------------------------------------------

function modifier_honkai_debuff:IsHidden() return false end

function modifier_honkai_debuff:IsDebuff() return true end

function modifier_honkai_debuff:IsPurgable() return false end

function modifier_honkai_debuff:RemoveOnDeath() return true end
--------------------------------------------------------------------------------

function modifier_honkai_debuff:OnCreated( kv )
	self.armor_bouns = self:GetAbility():GetSpecialValueFor("armor_bonus")
	self.ms_slow = self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
	self.damage_pct = self:GetAbility():GetSpecialValueFor("damage")
	self.dot_damage_level = self:GetAbility():GetSpecialValueFor("dot_stack")
	self.kill_level = self:GetAbility():GetSpecialValueFor("max_stack")
	self.damage_type = DAMAGE_TYPE_PURE 
	self.stack_count = self:GetStackCount()
	self.doDamage = false
	if not IsServer() then return end
	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage_type = self.damage_type,
		ability = self:GetAbility(), --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS --Optional.
	}
	self:SetStackCount(kv.extra_stack)
	-- ApplyDamage(damageTable)
	
	-- Start interval
	
	self:StartIntervalThink( 3 )
end

function modifier_honkai_debuff:OnRefresh( kv )
	self.stack_count = self:GetStackCount()
	if kv.extra_stack == nil then
		
	else
		self:SetStackCount(math.max(kv.extra_stack+self.stack_count,0))
	end
end

function modifier_honkai_debuff:OnStackCountChanged(kv)
	self.stack_count = self:GetStackCount()
	if self.stack_count > self.kill_level then
		self:GetParent():Kill(self:GetAbility(), self:GetCaster())
	end
end

function modifier_honkai_debuff:DeclareFunctions()

	local funcs = {

	}

	return funcs
end

function modifier_honkai_debuff:OnIntervalThink()
	if self.stack_count < self.dot_damage_level then
		return
	end
	
	local max_health = self:GetParent():GetMaxHealth()
	self.damageTable.damage = max_health*((self.damage_pct*(self:GetStackCount()-5))*(self.damage_pct*(self:GetStackCount()-5)))/10000
	ApplyDamage( self.damageTable )
end

function modifier_honkai_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end

function modifier_honkai_debuff:GetModifierPhysicalArmorBonus( params )
	return self.armor_bonus
end
