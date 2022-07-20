item_level_up = class({})

function item_level_up:OnSpellStart()
	self:GetCaster():HeroLevelUp(true)
end