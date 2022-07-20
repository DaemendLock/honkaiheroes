item_honkai_woodcutter_artifact = class({})

function item_honkai_woodcutter_artifact:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorTarget()
	point:CutDown(caster:GetTeamNumber())
	caster:ModifyGold(15, false, DOTA_ModifyGold_NeutralKill)
	EmitSoundOnEntityForPlayer("General.Coins", caster, caster:GetPlayerID())
end