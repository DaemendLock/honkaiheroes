LinkLuaModifier( "modifier_share_count", "keys/item_key_of_domination", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_share_key", "keys/item_key_of_domination", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_key_of_domination_stats", "keys/item_key_of_domination", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_honkai_debuff", "honkai/modifier_honkai_debuff", LUA_MODIFIER_MOTION_NONE )	
LinkLuaModifier( "modifier_honkai_penalti", "honkai/modifier_honkai_penalti", LUA_MODIFIER_MOTION_NONE )	

item_key_of_domination = class({})

item_key_of_domination.copies = 1

function item_key_of_domination:GetIntrinsicModifierName()
	return "modifier_key_of_domination_stats"
end

function item_key_of_domination:OnSpellStart()
	local caster = self:GetCaster()
	for i=0,8 do
		local item = caster:GetItemInSlot(i)
		if item and i ~= self:GetItemSlot() then
			if item:GetAbilityName() == self:GetAbilityName() then
				self.copies = self.copies*item.copies/(item.copies + self.copies)
				caster:RemoveItem(item)
				return
			end
		end
	end
	local honka = caster:FindModifierByName("modifier_honkai_penalti")
	local honkaEnt = honka:GetCaster()
	caster:AddNewModifier(honkaEnt,
						  honka:GetAbility(),
						  "modifier_honkai_debuff",
						  {extra_stack = self:GetSpecialValueFor("apply_stacks")}
						  )
	self.copies = self.copies * 2
	local copy = caster:AddItemByName("item_key_of_domination")
	--item_key_of_domination.copies = item_key_of_domination.copies + 1
	
	copy.copies = self.copies
	--end	
end

function item_key_of_domination:OnInventoryContentsChanged()
	print("Daemend")
	self:RefreshIntrinsicModifier()
end

modifier_key_of_domination_stats = class({})

function modifier_key_of_domination_stats:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_key_of_domination_stats:IsHidden()
	return false
end

function modifier_key_of_domination_stats:OnCreated(kv)
	self.base_as	= self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
	self.base_damage	= self:GetAbility():GetSpecialValueFor("damage_bonus")
	if IsServer() then
		self:SetStackCount(self:GetAbility().copies)
	else
		self:GetAbility().copies = self:GetStackCount()
	end
end

function modifier_key_of_domination_stats:OnRefresh(kv)
	if IsServer() then
		self:SetStackCount(self:GetAbility().copies)
		self:SendBuffRefreshToClients()
		print(self:GetStackCount())
	else
		print(self:GetStackCount())
		self:GetAbility().copies = self:GetStackCount()
	end
end

function modifier_key_of_domination_stats:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end

function modifier_key_of_domination_stats:GetModifierAttackSpeedBonus_Constant()
	return self.base_as / self:GetAbility().copies
end

function modifier_key_of_domination_stats:GetModifierPreAttack_BonusDamage()
	return self.base_damage / self:GetAbility().copies
end

modifier_share_count = class({})

modifier_share_key = class({})

