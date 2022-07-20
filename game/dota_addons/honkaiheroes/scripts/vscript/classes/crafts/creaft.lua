craftItem = class({})

craftItem.craftData = {
	techLevel = 0,
	craft_item = "item_craft_item",
	craft_table = {
		["item_honkai_piece"] = 10,
		["item_bottle"] = 1
	},
	craft_time = 10 
}

--function craftItem:canCraft(player)
--	return self:HasMaterials(player)
--end