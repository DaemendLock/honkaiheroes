item_honkai_builder_artifact = class({})

function item_honkai_builder_artifact:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorTarget()
	point:CutDown(caster:GetTeamNumber())
	caster:ModifyGold(20, false, DOTA_ModifyGold_NeutralKill)
	EmitSoundOnEntityForPlayer("General.Coins", caster, caster:GetPlayerID())
end