stigmata_menu = class({})

function stigmata_menu:StartListnening()
	if not IsServer() then return end
	self.open_listener = CustomGameEventManager:RegisterListener("open_request", Dynamic_Wrap(stigmata_menu, "OpenWindow"))
	self.close_listener = CustomGameEventManager:RegisterListener("close_request", Dynamic_Wrap(stigmata_menu, "CloseWindow"))
end

function checkSet(stigma)
	return stigma:checkSet()
end

function stigmata_menu:OpenWindow(event)
	local unit = EntIndexToHScript(event.unitId)
	local top = unit.stigmata_t
	local mid = unit.stigmata_m
	local bot = unit.stigmata_b
	local set2;
	local set3;
	if top then 
	if top:checkSet() >= 2 then set2 = top:GetName():sub(0,-2).."2Set" end
	top = {name = top:GetName(),
	hp = top.hp_bonus,
	atk = top.atk_bonus,
	def = top.def_bonus,
	crt = top.crt_bonus,
	}
	end
	if mid then 
	if mid:checkSet() >= 2 then set2 = mid:GetName():sub(0,-2).."2Set" end
	mid= {name = mid:GetName(),
	hp = mid.hp_bonus,
	atk = mid.atk_bonus,
	def = mid.def_bonus,
	crt = mid.crt_bonus,
	} end
	if bot then
	if bot:checkSet() == 3 then set3 = bot:GetName():sub(0,-2).."3Set" end
	bot = {name = bot:GetName(),
	hp = bot.hp_bonus,
	atk = bot.atk_bonus,
	def = bot.def_bonus,
	crt = bot.crt_bonus,
	} end
	
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(event.PlayerID),"OpenStigmaEvent", {top = top, mid = mid, bot = bot, set2 = set2, set3 = set3})
end

function stigmata_menu:CloseWindow( event )
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(event.PlayerID), "CloseStigmaEvent", {})
end