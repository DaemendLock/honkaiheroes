"use strict";

class StigmaWindow { 
    
    constructor(contextPanel, currentlySelectedUnitID) {
        this.isTalentWindowCurrentlyOpen = false;
        this.isHudCurrentlyVisible = true;
	    this.currentlySelectedUnitID;
        this.talentsRows = 3;
        this.talentMap = new Map();
        this.currentlyPickedRowsSet = new Set();
        this.talentSetMap = new Map();

	// Panels
	   this.contextPanel;
	   this.talentWindow;
	   this.hudButtonContainer;
	   this.hudButton;
	   this.hudOverlay;
	   this.hudScene;

	// IDs
	   this.abilityTalentButtonID = "Stigma";

	// CSS classes
        this.cssTalendWindowOpen = "Stigma_Window_open";
        this.cssOverlaySelected = "visible_overlay";
        this.contextPanel = contextPanel;
		this.currentlySelectedUnitID = currentlySelectedUnitID;
		//this.talentWindow = this.GetHudRoot().FindChildTraverse("CustomUIRoot").FindChildTraverse("CustomUIContainer_Hud").FindChildTraverse("TalentsHeader").GetParent();
        
    //METHODS
		//this.AddStigmaHudTalentButton();
		//this.ConfigureTalentHud();
		//this.SubscribeToEvents();
		//this.InitializeHeroTalents();
		//this.ConfigureTalentAbilityButtons();
		//this.ConfigureTalentHotkey();    
    }
    GetHeroStigmata() {
		const currently_selected_hero = Players.GetLocalPlayerPortraitUnit();

		// Do nothing if the current player is not a hero
		if (!Entities.IsHero(currently_selected_hero)) return;

		if (currently_selected_hero != this.currentlySelectedUnitID) {
			// Update currently selected hero unit
			this.currentlySelectedUnitID = currently_selected_hero;

			// Update talents
			this.InitializeHeroTalents();
		}
	}
    
    AddStigmaHudTalentButton() {
		// Find the ability bar
		const abilityBar = this.GetHudRoot()
			.FindChildTraverse("HUDElements")
			.FindChildTraverse("lower_hud")
			.FindChildTraverse("center_with_stats")
			.FindChildTraverse("center_block")
			.FindChildTraverse("AbilitiesAndStatBranch")
			.FindChildTraverse("StatBranch")
			.GetParent();

		// Find old button and delete if relevant
		const oldHudButtonContainer = abilityBar.FindChildTraverse("talent_btn_container");
		if (oldHudButtonContainer) {
			oldHudButtonContainer.DeleteAsync(0);
		}

		this.hudButtonContainer = $.CreatePanel("Panel", abilityBar, "talent_btn_container");
		const abilityList = abilityBar.FindChildTraverse("StatBranch");
		this.hudButtonContainer.BLoadLayout("file://{resources}/layout/custom_game/talent_hud.xml", true, false);
		this.hudButtonContainer.SetParent(abilityBar);
		abilityBar.MoveChildAfter(this.hudButtonContainer, abilityList);

		// Find the button inside the container
		this.hudButton = this.hudButtonContainer.FindChildTraverse("talent_hud_btn");
	}
    
    
    
    
    
    ToggleTalentWindow() {
		// Currently close: open!
		if (!this.isTalentWindowCurrentlyOpen) {
			this.GetHeroTalents();
			this.isTalentWindowCurrentlyOpen = true;
			this.talentWindow.AddClass(this.cssTalendWindowOpen);
			this.hudOverlay.AddClass(this.cssOverlaySelected);
            return;
		} 
        this.isTalentWindowCurrentlyOpen = false;
        this.talentWindow.RemoveClass(this.cssTalendWindowOpen);
        Game.EmitSound("ui_chat_slide_out");
        this.hudOverlay.RemoveClass(this.cssOverlaySelected);
		
	}
    
    
    SetMouseCallback(event, value){
		if (this.isTalentWindowCurrentlyOpen && value == CLICK_BEHAVIORS.DOTA_CLICK_BEHAVIOR_NONE) {
			if (event == "pressed") {
				const cursorPos = GameUI.GetCursorPosition();
				if (
					cursorPos[0] < this.talentWindow.actualxoffset ||
					this.talentWindow.actualxoffset + this.talentWindow.contentwidth < cursorPos[0] ||
					cursorPos[1] < this.talentWindow.actualyoffset ||
					this.talentWindow.actualyoffset + this.talentWindow.contentheight < cursorPos[1]
				) {
					const currentUnit = this.currentlySelectedUnitID;
					$.Schedule(0, () => {
						// Only close the window if we didn't change the selection of units
						if (Players.GetLocalPlayerPortraitUnit() == currentUnit) {
							this.ToggleTalentWindow();
						}
					});
				}
			}
		}

		return false;
	}

    RecurseEnableFocus(panel) {
		panel.SetAcceptsFocus(true);
		const children = panel.Children();

		children.forEach((child) => {
			this.RecurseEnableFocus(child);
		});
	}
}


var contextPanel = $.GetContextPanel();

function RemoveDotaTalentTree() {
	// Find the talent tree and disable it
	const talentTree = GetHudRoot()
		.FindChildTraverse("HUDElements")
		.FindChildTraverse("lower_hud")
		.FindChildTraverse("center_with_stats")
		.FindChildTraverse("center_block")
		.FindChildTraverse("AbilitiesAndStatBranch")
		.FindChildTraverse("StatBranch");
	talentTree.style.visibility = "collapse";
	talentTree.SetPanelEvent("onmouseover", function () {});
	talentTree.SetPanelEvent("onactivate", function () {});
	// Disable the level up frame for the talent tree
	const levelUpButton = GetHudRoot()
		.FindChildTraverse("HUDElements")
		.FindChildTraverse("lower_hud")
		.FindChildTraverse("center_with_stats")
		.FindChildTraverse("center_block")
		.FindChildTraverse("level_stats_frame");
	levelUpButton.style.visibility = "collapse";
}
var winStigma;
var winSet;
var stigmaT = [];
var stigmaM = [];
var stigmaB = [];
var stigma2Set = [];
var stigma3Set = [];

function OnStigmataSwap(event){
	var str = "#DOTA_Tooltip_ability_"+event.name;
	if(event.setPos==1){
	stigmaT.name.text =  $.Localize( str );
	stigmaT.item_png.itemname =  event.name;
	stigmaT.description.text = $.Localize(str+"_StigmaDescription");
	stigmaT.hp.text = $.Localize(str+"_hp_bonus")+event.hp;
	stigmaT.atk.text = $.Localize(str+"_atk_bonus")+event.atk;
	stigmaT.def.text = $.Localize(str+"_def_bonus")+event.def;
	stigmaT.crt.text = $.Localize(str+"_crt_bonus")+event.crt;
	return;
	} 
	if(event.setPos==2){
	stigmaM.name.text =  $.Localize( str );
	stigmaM.item_png.itemname =  event.name;
	stigmaM.description.text = $.Localize(str+"_StigmaDescription");
	stigmaM.hp.text = $.Localize(str+"_hp_bonus")+event.hp;
	stigmaM.atk.text = $.Localize(str+"_atk_bonus")+event.atk;
	stigmaM.def.text = $.Localize(str+"_def_bonus")+event.def;
	stigmaM.crt.text = $.Localize(str+"_crt_bonus")+event.crt;
	return;
	} 
	if(event.setPos==3){
	stigmaB.name.text =  $.Localize( str );
	stigmaB.item_png.itemname =  event.name;
	stigmaB.description.text = $.Localize(str+"_StigmaDescription");
	stigmaB.hp.text = $.Localize(str+"_hp_bonus")+event.hp;
	stigmaB.atk.text = $.Localize(str+"_atk_bonus")+event.atk;
	stigmaB.def.text = $.Localize(str+"_def_bonus")+event.def;
	stigmaB.crt.text = $.Localize(str+"_crt_bonus")+event.crt;
	return;
	} 
	
}

function OnStigmataSet(event){
	if(event.dispatch){
	if (event.set == 2){
	stigma2Set.description.text = $.Localize("#"+event.dispatch);
	}
	if (event.set == 3){
	stigma3Set.description.text = $.Localize("#"+event.dispatch);
	}
	} else {
		if (event.set == 2 && $.Localize("#"+event.name)==stigma2Set.description.text)
	stigma2Set.description.text = "";
	if (event.set == 3 && $.Localize("#"+event.name)==stigma3Set.description.text)
	stigma3Set.description.text = "";
	}
}

function GetHudRoot() {
	return contextPanel.GetParent().GetParent().GetParent();
}

var panel;

function InitMenu() {
	//contextPanel.visible = false; 
	panel = $.CreatePanel('Panel', $.GetContextPanel(),'');
	panel.BLoadLayoutSnippet('stigmata_window');
	winStigma = panel.FindChildTraverse("stigmata"); 
	winSet = panel.FindChildTraverse("set_bonus");  
	stigmaT.panel = winStigma.FindChildTraverse("stigmata_t");
	stigmaT.name = stigmaT.panel.FindChildTraverse("stigma_image").FindChildrenWithClassTraverse("StigmaName")[0];  
	stigmaT.item_png = stigmaT.panel.FindChildTraverse("stigma_image").FindChildTraverse("top_image");
	stigmaT.description = stigmaT.panel.FindChildrenWithClassTraverse("StigmaDesc")[0].FindChildTraverse("bot_desc");
	stigmaT.hp = stigmaT.panel.FindChildrenWithClassTraverse("StigmaDesc")[0].FindChildrenWithClassTraverse("StigmaStats")[0].FindChildTraverse("stigma_hp");
	stigmaT.atk = stigmaT.panel.FindChildrenWithClassTraverse("StigmaDesc")[0].FindChildrenWithClassTraverse("StigmaStats")[0].FindChildTraverse("stigma_atk");
	stigmaT.def = stigmaT.panel.FindChildrenWithClassTraverse("StigmaDesc")[0].FindChildrenWithClassTraverse("StigmaStats")[0].FindChildTraverse("stigma_def");
	stigmaT.crt = stigmaT.panel.FindChildrenWithClassTraverse("StigmaDesc")[0].FindChildrenWithClassTraverse("StigmaStats")[0].FindChildTraverse("stigma_crt");
	
	stigmaM.panel = winStigma.FindChildTraverse("stigmata_m");
	stigmaM.name = stigmaM.panel.FindChildTraverse("stigma_image").FindChildrenWithClassTraverse("StigmaName")[0];  
	stigmaM.item_png = stigmaM.panel.FindChildTraverse("stigma_image").FindChildTraverse("top_image");
	stigmaM.description = stigmaM.panel.FindChildrenWithClassTraverse("StigmaDesc")[0].FindChildTraverse("bot_desc");
	stigmaM.hp = stigmaM.panel.FindChildrenWithClassTraverse("StigmaDesc")[0].FindChildrenWithClassTraverse("StigmaStats")[0].FindChildTraverse("stigma_hp");
	stigmaM.atk = stigmaM.panel.FindChildrenWithClassTraverse("StigmaDesc")[0].FindChildrenWithClassTraverse("StigmaStats")[0].FindChildTraverse("stigma_atk");
	stigmaM.def = stigmaM.panel.FindChildrenWithClassTraverse("StigmaDesc")[0].FindChildrenWithClassTraverse("StigmaStats")[0].FindChildTraverse("stigma_def");
	stigmaM.crt = stigmaM.panel.FindChildrenWithClassTraverse("StigmaDesc")[0].FindChildrenWithClassTraverse("StigmaStats")[0].FindChildTraverse("stigma_crt");
	
	stigmaB.panel = winStigma.FindChildTraverse("stigmata_b");
	stigmaB.name = stigmaB.panel.FindChildTraverse("stigma_image").FindChildrenWithClassTraverse("StigmaName")[0];  
	stigmaB.item_png = stigmaB.panel.FindChildTraverse("stigma_image").FindChildTraverse("top_image");
	stigmaB.description = stigmaB.panel.FindChildrenWithClassTraverse("StigmaDesc")[0].FindChildTraverse("bot_desc");
	stigmaB.hp = stigmaB.panel.FindChildrenWithClassTraverse("StigmaDesc")[0].FindChildrenWithClassTraverse("StigmaStats")[0].FindChildTraverse("stigma_hp");
	stigmaB.atk = stigmaB.panel.FindChildrenWithClassTraverse("StigmaDesc")[0].FindChildrenWithClassTraverse("StigmaStats")[0].FindChildTraverse("stigma_atk");
	stigmaB.def = stigmaB.panel.FindChildrenWithClassTraverse("StigmaDesc")[0].FindChildrenWithClassTraverse("StigmaStats")[0].FindChildTraverse("stigma_def");
	stigmaB.crt = stigmaB.panel.FindChildrenWithClassTraverse("StigmaDesc")[0].FindChildrenWithClassTraverse("StigmaStats")[0].FindChildTraverse("stigma_crt");
	
	stigma2Set.panel = winSet.FindChildTraverse("stigmata_2set");
	stigma2Set.description = stigma2Set.panel.FindChildTraverse("set2_desc");
	stigma3Set.panel = winSet.FindChildTraverse("stigmata_3set");
	stigma3Set.description = stigma3Set.panel.FindChildTraverse("set3_desc");
	panel.visible = false;
	
}

function OnOpenRequest(event){
	panel.visible = true;
	var str = "#DOTA_Tooltip_ability_item_";
	
	if(event.top != null){
	stigmaT.name.text =  $.Localize(str + event.top.name );
	stigmaT.item_png.itemname =  "item_"+event.top.name;
	stigmaT.description.text = $.Localize(str+event.top.name+"_StigmaDescription");
	stigmaT.hp.text = $.Localize(str+event.top.name+"_hp_bonus")+event.top.hp;
	stigmaT.atk.text = $.Localize(str+event.top.name+"_atk_bonus")+event.top.atk;
	stigmaT.def.text = $.Localize(str+event.top.name+"_def_bonus")+event.top.def;
	stigmaT.crt.text = $.Localize(str+event.top.name+"_crt_bonus")+event.top.crt;
	}
	else{
	stigmaT.name.text = "";
	stigmaT.item_png.itemname =  "";
	stigmaT.description.text = "";
	stigmaT.hp.text = "HP: 0";
	stigmaT.atk.text = "ATK: 0";
	stigmaT.def.text = "DEF: 0";
	stigmaT.crt.text = "CRT: 0";
	}
	if(event.mid != null){
	stigmaM.name.text =  $.Localize( str+event.mid.name );
	stigmaM.item_png.itemname =  "item_"+event.mid.name;
	stigmaM.description.text = $.Localize(str+event.mid.name+"_StigmaDescription");
	stigmaM.hp.text = $.Localize(str+event.mid.name+"_hp_bonus")+event.mid.hp;
	stigmaM.atk.text = $.Localize(str+event.mid.name+"_atk_bonus")+event.mid.atk;
	stigmaM.def.text = $.Localize(str+event.mid.name+"_def_bonus")+event.mid.def;
	stigmaM.crt.text = $.Localize(str+event.mid.name+"_crt_bonus")+event.mid.crt;
	}
	else
	{
	stigmaM.name.text = "";
	stigmaM.item_png.itemname =  "";
	stigmaM.description.text = "";
	stigmaM.hp.text = "HP: 0";
	stigmaM.atk.text = "ATK: 0";
	stigmaM.def.text = "DEF: 0";
	stigmaM.crt.text = "CRT: 0";
	}
	if(event.bot != null){
	stigmaB.name.text =  $.Localize( str +event.bot.name);
	stigmaB.item_png.itemname =  "item_"+event.bot.name;
	stigmaB.description.text = $.Localize(str+event.bot.name+"_StigmaDescription");
	stigmaB.hp.text = $.Localize(str+event.bot.name+"_hp_bonus")+event.bot.hp;
	stigmaB.atk.text = $.Localize(str+event.bot.name+"_atk_bonus")+event.bot.atk;
	stigmaB.def.text = $.Localize(str+event.bot.name+"_def_bonus")+event.bot.def;
	stigmaB.crt.text = $.Localize(str+event.bot.name+"_crt_bonus")+event.bot.crt;
	}
	else{
	stigmaB.name.text = "";
	stigmaB.item_png.itemname =  "";
	stigmaB.description.text = "";
	stigmaB.hp.text = "HP: 0";
	stigmaB.atk.text = "ATK: 0";
	stigmaB.def.text = "DEF: 0";
	stigmaB.crt.text = "CRT: 0";
	}
	if (event.set2 != null){
	stigma2Set.description.text = $.Localize("#"+event.set2);
	}
	else{
		stigma2Set.description.text = "";
	}
	if (event.set3 != null){
	stigma3Set.description.text = $.Localize("#"+event.set3);
	}
	else{
		stigma3Set.description.text = "";
	}
}
function OnCloseRequest(event){
	panel.visible = false;
}

function close_request(eventName, args){
	panel.visible = false;
	return true;
}

function open_request(){
	if (panel.visible){
			close_request();
			return;
	}
	if (!GameUI.IsControlDown()) return;
	const currently_selected_unit = Players.GetLocalPlayerPortraitUnit();
	GameEvents.SendCustomGameEventToServer("open_request", {unitId: currently_selected_unit});
}

function RecurseEnableFocus(panelV) {
	panelV.SetAcceptsFocus(true);
	const children = panelV.Children();
	children.forEach((child) => {
		RecurseEnableFocus(child);
	});
}
	
function ConfigureTalentHotkey() { 
	const talentHotkey = Game.GetKeybindForCommand(DOTAKeybindCommand_t.DOTA_KEYBIND_LEARN_STATS);
	Game.CreateCustomKeyBind(talentHotkey, "StigmataHotkey");
	Game.AddCommand("StigmataHotkey", open_request, "", 0);
	RecurseEnableFocus(panel);
	$.RegisterKeyBind(panel, "key_escape", close_request);
}


 



(function () {
	RemoveDotaTalentTree(); 
	InitMenu();
	ConfigureTalentHotkey();

	var change_event = GameEvents.Subscribe( "StigmaSwap", OnStigmataSwap ); 
	var set_event = GameEvents.Subscribe( "StigmaSetGain", OnStigmataSet );
	var open_event = GameEvents.Subscribe( "OpenStigmaEvent", OnOpenRequest );
	var close_event = GameEvents.Subscribe( "CloseStigmaEvent", OnCloseRequest );
   
})();