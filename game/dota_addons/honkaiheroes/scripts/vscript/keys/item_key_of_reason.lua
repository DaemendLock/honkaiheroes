LinkLuaModifier( "modifier_honkai_debuff", "honkai/modifier_honkai_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_key_of_reason_sim", "keys/item_key_of_reason_items", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "item_key_of_reason_choose", "keys/item_key_of_reason", LUA_MODIFIER_MOTION_NONE )

item_key_of_reason = class({})

item_key_of_reason.items = { "item_key_of_reason_bkb", "item_key_of_reason_refresher", "item_key_of_reason_dagon_5", "item_key_of_reason_blink", "item_key_of_reason_hex"}
item_key_of_reason.item_cost = {
  ["item_key_of_reason_bkb"]= 4, 
  ["item_key_of_reason_refresher"] = 8,
  ["item_key_of_reason_dagon_5"] = 2, 
  ["item_key_of_reason_blink"] = 2, 
  ["item_key_of_reason_hex"] = 5, 
  ["item_key_of_reason_silver_edge"] = 3
  }


function item_key_of_reason:OnSpellStart()
	if not IsServer() or self:GetCaster():HasModifier("item_key_of_reason_choose") then return end
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	caster:AddNewModifier(caster, self, "item_key_of_reason_choose", {})
	for _, item_name in pairs(self.items) do
		CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "key_of_reason_add_item", {item_name = item_name, item_cost = self.item_cost[item_name]})
	end
	
end


item_key_of_reason_choose = class({})

function item_key_of_reason_choose:EndChoose(player)
	CustomGameEventManager:Send_ServerToPlayer(player:GetPlayerOwner(), "key_of_reason_close_event",  {})
end

function item_key_of_reason_choose:OnItemPicked(event)
	local self = EntIndexToHScript(event.aid)
	local caster = self:GetCaster()
	if caster:HasItemInInventory("item_key_of_reason") then
	local buff = caster:AddNewModifier(caster, self, "modifier_key_of_reason_sim", {duration = 10, item_name = event.item_name})
	if not buff then return end
	end
	item_key_of_reason_choose:EndChoose(caster)
end

function item_key_of_reason_choose:OnWindowClosed(event)
	if not IsServer() then return end
	local self = EntIndexToHScript(event.aid)
	local caster = self:GetCaster()
	local buff = caster:FindModifierByName("item_key_of_reason_choose")
	if buff ~= nil then buff:Destroy() end
end

function item_key_of_reason_choose:OnCreated()
	if not IsServer() then return end
	CustomGameEventManager:Send_ServerToPlayer(self:GetCaster():GetPlayerOwner(), "key_of_reason_cast_event", {aid = self:GetAbility():GetEntityIndex()})
	self.listner = CustomGameEventManager:RegisterListener("key_of_reason_item_pick", Dynamic_Wrap(item_key_of_reason_choose, "OnItemPicked"))
	self.listner_close = CustomGameEventManager:RegisterListener("key_of_reason_window_close_event", Dynamic_Wrap(item_key_of_reason_choose, "OnWindowClosed"))
end

function item_key_of_reason_choose:IsHiden()
	return true
end

function item_key_of_reason_choose:OnRemoved()

end


