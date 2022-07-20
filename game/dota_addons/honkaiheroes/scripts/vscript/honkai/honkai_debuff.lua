honkai_debuff = class({})
LinkLuaModifier( "modifier_honkai_debuff", "honkai/modifier_honkai_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function honkai_debuff:GetIntrinsicModifierName()
	return "modifier_honkai_debuff"
end