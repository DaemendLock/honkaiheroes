item_summon_hot = class({})

function item_summon_hot:OnSpellStart()
	CreateUnitByName("npc_herrscher_thunder", Vector(0,0,0), false, nil, nil, DOTA_TEAM_NEUTRALS )
	self:SpendCharge()
end