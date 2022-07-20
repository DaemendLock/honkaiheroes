LinkLuaModifier("modifier_honkai_antidot","items/item_honkai_antidot",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_honkai_debuff", "honkai/modifier_honkai_debuff", LUA_MODIFIER_MOTION_NONE )	
LinkLuaModifier( "modifier_honkai_penalti", "honkai/modifier_honkai_penalti", LUA_MODIFIER_MOTION_NONE )	

item_honkai_antidot = class({})

function item_honkai_antidot:Precache()
	--PrecacheResource( "soundfile", "soundevents/", context )
end

function item_honkai_antidot:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	target:AddNewModifier(caster, self, "modifier_honkai_antidot", {duration = self:GetDuration()})
	print("find honkai")
	local honka = target:FindModifierByName("modifier_honkai_penalti")
	local honkaEnt = honka:GetCaster()
	print("found honkai")
	target:AddNewModifier(honkaEnt,
						  honka:GetAbility(),
						  "modifier_honkai_debuff",
						  {extra_stack = self:GetSpecialValueFor("apply_stacks")}
						  )
	self:SpendCharge()
	target:EmitSound("DOTA_Item.Tango.Activate")
end

modifier_honkai_antidot = class({})

function modifier_honkai_antidot:OnCreated(kv)
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.ms_pct = self.ability:GetSpecialValueFor("ms_pct")
	self.armor = self.ability:GetSpecialValueFor("bonus_armor")
	self.damage = self.ability:GetSpecialValueFor("bonus_damage")
end

function modifier_honkai_antidot:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT ,
	}
	return func
end

function modifier_honkai_antidot:GetEffectName() return "particles/econ/courier/courier_greevil_purple/courier_greevil_purple_ambient_1.vpcf" end
function modifier_honkai_antidot:GetModifierMoveSpeedBonus_Constant() return self.ms_pct end
function modifier_honkai_antidot:GetModifierPhysicalArmorBonus() return self.armor end
function modifier_honkai_antidot:GetModifierPreAttack_BonusDamage() return self.damage end
function modifier_honkai_antidot:GetTexture() return "item_honkai_antidot" end