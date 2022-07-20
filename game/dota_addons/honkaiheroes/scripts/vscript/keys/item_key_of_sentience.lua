LinkLuaModifier( "modifier_item_key_of_sentience_sleep", "keys/item_key_of_sentience", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_key_of_sentience_buff", "keys/item_key_of_sentience", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_key_of_sentience_dust", "keys/item_key_of_sentience", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_key_of_sentience_leaved", "keys/item_key_of_sentience", LUA_MODIFIER_MOTION_NONE )

item_key_of_sentience = class({})

function item_key_of_sentience:GetIntrinsicModifierName() return "modifier_item_key_of_sentience_dust" end

function item_key_of_sentience:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	if target:GetTeam() ~= caster:GetTeam() then
		target:AddNewModifier(caster, self, "modifier_item_key_of_sentience_sleep", {duration = self:GetSpecialValueFor("sleep_duration")})
		self:StartCooldown(self:GetSpecialValueFor("sleep_cd"))
	else
		if target~=caster then
			target:AddNewModifier(caster, self, "modifier_item_key_of_sentience_buff", {duration = self:GetSpecialValueFor("buff_duration")})
			target:AddNewModifier(caster, self, "modifier_item_key_of_sentience_dust", {duration = self:GetSpecialValueFor("buff_duration")})
			self:StartCooldown(self:GetSpecialValueFor("buff_cd"))
		else
			self.senti = CreateUnitByName( caster:GetUnitName(),
											caster:GetAbsOrigin(), 
											true, self:GetCaster(), 
											self:GetCaster():GetOwner(), self:GetCaster():GetTeamNumber() )
			if self.senti ~= nil then
				self:ModifyIllusion()
			end
		end
	end
end

function item_key_of_sentience:ModifyIllusion()
				self.senti:SetControllableByPlayer( self:GetCaster():GetPlayerID(), false )
				self.senti:SetOwner( self:GetCaster())
				for i=0,23 do
					local abi = self.senti:GetAbilityByIndex(i)
					if abi then
						self.senti:RemoveAbilityByHandle(abi)
					end
				end
				self.senti:AddAbility("retrix")
				self.senti:GetAbilityByIndex(0):SetLevel(1)
				self.senti:AddAbility("cinder")
				self.senti:GetAbilityByIndex(1):SetLevel(1)
				self.senti:AddAbility("featherdown")
				self.senti:GetAbilityByIndex(2):SetLevel(1)
				self.senti:AddAbility("flamingheart")
				self.senti:GetAbilityByIndex(3):SetLevel(1)
				self.senti:AddAbility("rainbowpinion")
				self.senti:GetAbilityByIndex(4):SetLevel(1)
				self.senti:AddAbility("flamegust")
				self.senti:GetAbilityByIndex(5):SetLevel(1)
				self.senti:SetIdleAcquire(false)
end

function item_key_of_sentience:FeatherDown()
	
end

function item_key_of_sentience:PhoenixDust()
	
end

modifier_item_key_of_sentience_dust = class({})

function modifier_item_key_of_sentience_dust:OnCreated()
	self.mana_cost = self:GetAbility():GetSpecialValueFor("cheatdeath_mana_cost")
	
end

function modifier_item_key_of_sentience_dust:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK_UNAVOIDABLE_PRE_ARMOR ,
		
	}
end

function modifier_item_key_of_sentience_dust:GetModifierBonusStats_ElementalDamage()
	return 10
end
function modifier_item_key_of_sentience_dust:GetModifierPhysical_ConstantBlockUnavoidablePreArmor(event)
	if self:GetParent():GetHealth() <= event.damage+1 and self:GetCaster():GetMana() > self.mana_cost then
	local particle_cast = "particles/econ/items/vengeful/vs_ti8_immortal_shoulder/vs_ti8_immortal_magic_missle_crimson_end_feathers.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 3, event.target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	event.target:EmitSoundParams("Hero_DragonKnight.Attack", 1, 4, 2)
	self:GetCaster():SpendMana(self.mana_cost, self)
	--event.target:CreatureLevelUp(-1)
	return event.damage
	end
	return 0
end

modifier_item_key_of_sentience_sleep = class({})

function modifier_item_key_of_sentience_sleep:IsHidden()
	return false
end

function modifier_item_key_of_sentience_sleep:IsDebuff()
	return true
end

function modifier_item_key_of_sentience_sleep:IsStunDebuff()
	return false
end

function modifier_item_key_of_sentience_sleep:IsPurgable()
	return true
end

function modifier_item_key_of_sentience_sleep:OnCreated()
	self.damage = self:GetAbility():GetSpecialValueFor("sleep_damage")
	self.vision = self:GetAbility():GetSpecialValueFor("vision_radius")
end

function modifier_item_key_of_sentience_sleep:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_FIXED_DAY_VISION,
		MODIFIER_PROPERTY_FIXED_NIGHT_VISION
		
	}
end

function modifier_item_key_of_sentience_sleep:GetFixedNightVision() return self.vision end
function modifier_item_key_of_sentience_sleep:GetFixedDayVision()	return self.vision end

function modifier_item_key_of_sentience_sleep:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_NIGHTMARED] = true
	}
	return state
end

function modifier_item_key_of_sentience_sleep:OnTakeDamage(kv)
	if not IsServer() or kv.unit ~= self:GetParent() then return end
	self.damage = self.damage-kv.damage
	if self.damage<=0 then
		self:Destroy()
	end
end

modifier_item_key_of_sentience_buff = class({})

function modifier_item_key_of_sentience_buff:IsHidden()
	return false
end

function modifier_item_key_of_sentience_buff:IsDebuff()
	return false
end

function modifier_item_key_of_sentience_buff:IsPurgable()
	return true
end

function modifier_item_key_of_sentience_buff:OnCreated()
	self.buff_pct = self:GetAbility():GetSpecialValueFor("buff_pct")
	self.buff_mana_pct = self:GetAbility():GetSpecialValueFor("buff_mana_pct")
end

function modifier_item_key_of_sentience_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_SPENT_MANA
	}
end
function modifier_item_key_of_sentience_buff:GetModifierBonusStats_Intellect() return self:GetCaster():GetIntellect()*self.buff_pct/100 end
function modifier_item_key_of_sentience_buff:GetModifierPercentageManacost() return -1*self.buff_mana_pct end
function modifier_item_key_of_sentience_buff:OnSpentMana(kv) if kv.unit ~= self:GetParent() then return end self:GetCaster():SpendMana(kv.ability:GetManaCost(-1)*(self.buff_mana_pct/100),self:GetAbility()) end

modifier_item_key_of_sentience_leaved = class({})
