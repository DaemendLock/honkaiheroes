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
var gPanel;
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
	return;
	} 
	if(event.setPos==2){
	stigmaM.name.text =  $.Localize( str );
	stigmaM.item_png.itemname =  event.name;
	stigmaM.description.text = $.Localize(str+"_StigmaDescription");
	return;
	} 
	if(event.setPos==3){
	stigmaB.name.text =  $.Localize( str );
	stigmaB.item_png.itemname =  event.name;
	stigmaB.description.text = $.Localize(str+"_StigmaDescription");
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

function InitMenu() {
    var panel = $.CreatePanel('Panel', $.GetContextPanel(),'');
	panel.BLoadLayoutSnippet('stigmata_window');
	winStigma = panel.FindChildTraverse("stigmata"); 
	winSet = panel.FindChildTraverse("set_bonus");  
	stigmaT.panel = winStigma.FindChildTraverse("stigmata_t");
	stigmaT.name = stigmaT.panel.FindChildTraverse("stigma_image").FindChildrenWithClassTraverse("StigmaName")[0];  
	stigmaT.item_png = stigmaT.panel.FindChildTraverse("stigma_image").FindChildTraverse("top_image");
	stigmaT.description = stigmaT.panel.FindChildrenWithClassTraverse("StigmaDesc")[0].FindChildTraverse("bot_desc");
	
	stigmaM.panel = winStigma.FindChildTraverse("stigmata_m");
	stigmaM.name = stigmaM.panel.FindChildTraverse("stigma_image").FindChildrenWithClassTraverse("StigmaName")[0];  
	stigmaM.item_png = stigmaM.panel.FindChildTraverse("stigma_image").FindChildTraverse("top_image");
	stigmaM.description = stigmaM.panel.FindChildrenWithClassTraverse("StigmaDesc")[0].FindChildTraverse("bot_desc");
	
	stigmaB.panel = winStigma.FindChildTraverse("stigmata_b");
	stigmaB.name = stigmaB.panel.FindChildTraverse("stigma_image").FindChildrenWithClassTraverse("StigmaName")[0];  
	stigmaB.item_png = stigmaB.panel.FindChildTraverse("stigma_image").FindChildTraverse("top_image");
	stigmaB.description = stigmaB.panel.FindChildrenWithClassTraverse("StigmaDesc")[0].FindChildTraverse("bot_desc");
	
	stigma2Set.panel = winSet.FindChildTraverse("stigmata_2set");
	stigma2Set.description = stigma2Set.panel.FindChildTraverse("set2_desc");
	stigma3Set.panel = winSet.FindChildTraverse("stigmata_3set");
	stigma3Set.description = stigma3Set.panel.FindChildTraverse("set3_desc");
	gPanel.visible = false;
	
}

function OnOpenRequest(event){
	gPanel.visible = true;
	var str = "#DOTA_Tooltip_ability_";
	if(event.top != null){
	stigmaT.name.text =  $.Localize( str+event.top );
	stigmaT.item_png.itemname =  event.top;
	stigmaT.description.text = $.Localize(str+event.top+"_StigmaDescription");
	} 
	if(event.mid != null){
	stigmaM.name.text =  $.Localize( str+event.mid );
	stigmaM.item_png.itemname =  event.mid;
	stigmaM.description.text = $.Localize(str+event.mid+"_StigmaDescription");
	} 
	if(event.bot != null){
	stigmaB.name.text =  $.Localize( str +event.bot);
	stigmaB.item_png.itemname =  event.bot;
	stigmaB.description.text = $.Localize(str+event.bot+"_StigmaDescription");
	} 
}

function OnCloseRequest(event){
	
	gPanel.visible = false;
	
}

function open_request(){
		const currently_selected_unit = Players.GetLocalPlayerPortraitUnit();
		GameEvents.SendCustomGameEventToServer("open_request", {unitId: currently_selected_unit});
}


function ConfigureTalentHotkey() { 
	
	
	const talentHotkey = Game.GetKeybindForCommand(DOTAKeybindCommand_t.DOTA_KEYBIND_LEARN_STATS);
	GameUI.SetMouseCallback((event, value) => OnCloseRequest() );
	Game.CreateCustomKeyBind(talentHotkey, "StigmataHotkey");
	Game.AddCommand("StigmataHotkey", () => open_request(), "", 0);
	
	//Enable focus for talent window children (this is to allow catching of Escape button)
	//this.RecurseEnableFocus(this.contextPanel);
	//$.RegisterKeyBind(this.contextPanel, "key_escape", () => { 
		//if (this.isTalentWindowCurrentlyOpen) {
		//	this.ToggleTalentWindow();
		//}
	//});
	// Allow mouse clicks outside the talent window to close it.
	
}

(function () {
	RemoveDotaTalentTree();
	
	gPanel = $.GetContextPanel();	
	var change_event = GameEvents.Subscribe( "StigmaSwap", OnStigmataSwap );
	var set_event = GameEvents.Subscribe( "StigmaSetGain", OnStigmataSet );
	var open_event = GameEvents.Subscribe( "OpenStigmaEvent", OnOpenRequest );
	var close_event = GameEvents.Subscribe( "CloseStigmaEvent", OnCloseRequest );
	ConfigureTalentHotkey();
	
    InitMenu();
    var window = new StigmaWindow($.GetContextPanel(), null);
   
})();