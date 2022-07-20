item_key_of_hurricanes = class({})
LinkLuaModifier( "modifier_item_key_of_hurricanes_buff", "keys/item_key_of_hurricanes", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_honkai_debuff", "honkai/modifier_honkai_debuff", LUA_MODIFIER_MOTION_NONE )

function item_key_of_hurricanes:OnSpellStart()
	self.point = self:GetCursorPosition()
	self.radius = self:GetSpecialValueFor("radius")
	self.thinker = CreateModifierThinker(self:GetCaster(), self, "modifier_item_key_of_hurricanes_buff", {duration = self:GetSpecialValueFor("cast_duration")}, self.point, DOTA_TEAM_NOTEAM, false)
	local caster = self:GetCaster()
	local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),  self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_BOTH , 3, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
	local honka = caster:FindModifierByName("modifier_honkai_penalti")
	local honkaEnt = honka:GetCaster()
	local point = self.point+RandomVector(RandomInt(70,self.radius))
	CreateTempTree(point, 5*60)
	local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),  self.point, nil, self.radius, DOTA_UNIT_TARGET_TEAM_BOTH , 3, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
	for _, target in pairs(targets) do
		target:Heal(self:GetSpecialValueFor("heal_ammount"), self)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL ,target,self:GetSpecialValueFor("heal_ammount"), self:GetCaster())
		target:AddNewModifier(honkaEnt,
						  honka:GetAbility(),
						  "modifier_honkai_debuff",
						  {extra_stack = self:GetSpecialValueFor("decrees_stacks")}
						  )
	end

	caster:AddNewModifier(honkaEnt,
						  honka:GetAbility(),
						  "modifier_honkai_debuff",
						  {extra_stack = self:GetSpecialValueFor("apply_stacks")}
						  )
end

function item_key_of_hurricanes:OnChannelFinish(notfinish)
	if self.thinker and not self.thinker:IsNull() then
		self.thinker:Destroy()
	end
	
end


--MODIFIER--
modifier_item_key_of_hurricanes_buff = class({})

function modifier_item_key_of_hurricanes_buff:OnCreated()
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	local particle_cast = "particles/items_fx/gem_truesight_aura.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent())
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector(self.radius,  0 , 0) )
	ParticleManager:SetParticleControl( self.effect_cast, 0,	self:GetParent():GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
	self:StartIntervalThink( self:GetDuration()/self:GetAbility():GetSpecialValueFor("tick_count"))
end

function modifier_item_key_of_hurricanes_buff:OnRemoved()
	ParticleManager:DestroyParticle(self.effect_cast, false)
end

function modifier_item_key_of_hurricanes_buff:OnIntervalThink()
	self.point = self:GetParent():GetOrigin()
	local point = self.point+RandomVector(RandomInt(70,self.radius))
	CreateTempTree(point, 5*60)
	local caster = self:GetCaster()
	local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),  self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_BOTH , 3, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
	local honka = caster:FindModifierByName("modifier_honkai_penalti")
	local honkaEnt = honka:GetCaster()
	for _, target in pairs(targets) do
		target:Heal(self:GetAbility():GetSpecialValueFor("heal_ammount"), self:GetAbility())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL ,target,self:GetAbility():GetSpecialValueFor("heal_ammount"), self:GetCaster())
		
		target:AddNewModifier(honkaEnt,
						  honka:GetAbility(),
						  "modifier_honkai_debuff",
						  {extra_stack = self:GetAbility():GetSpecialValueFor("decrees_stacks")}
						  )
	end
end