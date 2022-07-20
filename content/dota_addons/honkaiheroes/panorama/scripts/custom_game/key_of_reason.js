"use strict";

var item_menu;
var close_event;
var cast_event;
var items = [];
var pIndex;
var aIndex;

function CreateItem(item){
    var item_panel = $.CreatePanel('Panel', item_menu.FindChildTraverse("ItemsListID") ,'')
    item_panel.BLoadLayoutSnippet('ItemSim');
    item_panel.FindChildTraverse("ItemPng").itemname = item.item_name;
    items.push(item_panel);
    item_panel.FindChildTraverse("itemcost").text = item.item_cost;
    return item_panel;
}

function DestroyMenu() {
	if (item_menu != null){
    item_menu.DeleteAsync(0);
    item_menu = null;
	items = [];
	GameEvents.SendCustomGameEventToServer("key_of_reason_window_close_event", {aid: aIndex});
	}
}
function ShowMenu() {
    var panel = $.CreatePanel('Panel', $.GetContextPanel(),'');
    panel.BLoadLayoutSnippet('key_menu');
	item_menu = panel;   
	
}

function OnClickEvent () {
    DestroyMenu();
}

function OnCreateItem(item){
    CreateItem(item)
}

function OnKeyCasted(event) {
    if (item_menu==null) {
		aIndex = event.aid;
        ShowMenu();
    }
    else {
        DestroyMenu();
    }
}

function ToAbsPixelValue( number ) {
    
    return Math.floor((1 / $.GetContextPanel().actualuiscale_x) * number);
}

class item_menu_pos{
    constructor(item_menu){
    var windowPosition = item_menu.GetPositionWithinWindow();
    this.posX = ToAbsPixelValue(windowPosition.x);
    this.posY = ToAbsPixelValue(windowPosition.y);
    this.height = ToAbsPixelValue(item_menu.actuallayoutheight);
    this.width = ToAbsPixelValue(item_menu.actuallayoutwidth);
    }
}

function ItemChoose(){
    var button;
    for (button of items){
    if (button.BHasHoverStyle()){
		GameEvents.SendCustomGameEventToServer("key_of_reason_item_pick", {aid: aIndex, item_name: button.FindChildTraverse("ItemPng").itemname});
		break;
    }
    }
}

var menu_pos;
(function () {
    var cast_event = GameEvents.Subscribe( "key_of_reason_cast_event", OnKeyCasted );
    var close_event = GameEvents.Subscribe( "key_of_reason_close_event", DestroyMenu );
    var close_event = GameEvents.Subscribe( "key_of_reason_add_item", OnCreateItem );
    
    GameUI.SetMouseCallback(function(event, button) {
	if (event=="wheeled" || button > 1 ) return false;
	GameEvents.SendCustomGameEventToServer("close_request", {});
    if (button != 0) return false;
    if (item_menu == null) return false;
    menu_pos = new item_menu_pos(item_menu);
	
    var cursorPos = GameUI.GetCursorPosition();
    if (
            cursorPos[0] >= menu_pos.posX &&
            cursorPos[0] <= menu_pos.posX+menu_pos.width &&
            cursorPos[1] >= menu_pos.posY &&
            cursorPos[1] <= menu_pos.posY+menu_pos.height
        
    )  {return false;}
            
    DestroyMenu();
    return false;
    });
    item_menu = null;
	
})();