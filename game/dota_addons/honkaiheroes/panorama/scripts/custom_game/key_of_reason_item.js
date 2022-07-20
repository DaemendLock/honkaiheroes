"use strict";

var m_Item = -1;
var m_QueryUnit = -1;

function UpdateItem()
{
	var itemName = Abilities.GetAbilityName( m_Item );
	var hotkey = Abilities.GetKeybind( m_Item, m_QueryUnit );
	var isPassive = Abilities.IsPassive( m_Item );
	var chargeCount = 0;
	var hasCharges = false;
	var altChargeCount = 0;
	var hasAltCharges = false;
	
	$( "#HotkeyText" ).text = hotkey;
	$( "#ItemImage" ).itemname = itemName;
	$( "#ItemImage" ).contextEntityIndex = m_Item;
}

function ItemShowTooltip()
{
	if ( m_Item == -1 )
		return;

	var itemName = Abilities.GetAbilityName( m_Item );
	$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", $.GetContextPanel(), itemName, m_QueryUnit );
}

function ItemHideTooltip()
{
	$.DispatchEvent( "DOTAHideAbilityTooltip", $.GetContextPanel() );
}

function ActivateItem()
{
	if ( m_Item == -1 )
		return;

	// Items are abilities - just execute the ability
	Abilities.ExecuteAbility( m_Item, m_QueryUnit, false );
}

function DoubleClickItem()
{
	ActivateItem();
}

var DOTA_ITEM_STASH_MIN = 6;

function IsInStash()
{
	return ( m_ItemSlot >= DOTA_ITEM_STASH_MIN );
}

function RightClickItem()
{
	ItemHideTooltip();

	var bSlotInStash = IsInStash();
	var bControllable = Entities.IsControllableByPlayer( m_QueryUnit, Game.GetLocalPlayerID() );
	var bSellable = Items.IsSellable( m_Item ) && Items.CanBeSoldByLocalPlayer( m_Item );
	var bDisassemble = Items.IsDisassemblable( m_Item ) && bControllable && !bSlotInStash;
	var bAlertable = Items.IsAlertableItem( m_Item );
	var bShowInShop = Items.IsPurchasable( m_Item );
	var bDropFromStash = bSlotInStash && bControllable;

	if ( !bSellable && !bDisassemble && !bShowInShop && !bDropFromStash && !bAlertable && !bMoveToStash )
	{
		// don't show a menu if there's nothing to do
		return;
	}

	var contextMenu = $.CreatePanel( "DOTAContextMenuScript", $.GetContextPanel(), "" );
	contextMenu.AddClass( "ContextMenu_NoArrow" );
	contextMenu.AddClass( "ContextMenu_NoBorder" );
	contextMenu.GetContentsPanel().data().Item = m_Item;
	contextMenu.GetContentsPanel().SetHasClass( "bSellable", bSellable );
	contextMenu.GetContentsPanel().SetHasClass( "bDisassemble", bDisassemble );
	contextMenu.GetContentsPanel().SetHasClass( "bShowInShop", bShowInShop );
	contextMenu.GetContentsPanel().SetHasClass( "bDropFromStash", bDropFromStash );
	contextMenu.GetContentsPanel().SetHasClass( "bAlertable", bAlertable );
	contextMenu.GetContentsPanel().SetHasClass( "bMoveToStash", false ); // TODO
	contextMenu.GetContentsPanel().BLoadLayout( "file://{resources}/layout/custom_game/inventory_context_menu.xml", false, false );
}

function OnDragEnter( a, draggedPanel )
{
	var draggedItem = draggedPanel.data().m_DragItem;

	// only care about dragged items other than us
	if ( draggedItem === null || draggedItem == m_Item )
		return true;

	// highlight this panel as a drop target
	$.GetContextPanel().AddClass( "potential_drop_target" );
	return true;
}

function OnDragDrop( panelId, draggedPanel )
{
	var draggedItem = draggedPanel.data().m_DragItem;
	
	// only care about dragged items other than us
	if ( draggedItem === null )
		return true;

	// executing a slot swap - don't drop on the world
	draggedPanel.data().m_DragCompleted = true;
	
	// item dropped on itself? don't acutally do the swap (but consider the drag completed)
	if ( draggedItem == m_Item )
		return true;

	// create the order
	var moveItemOrder =
	{
		OrderType: dotaunitorder_t.DOTA_UNIT_ORDER_MOVE_ITEM,
		TargetIndex: m_ItemSlot,
		AbilityIndex: draggedItem
	};
	Game.PrepareUnitOrders( moveItemOrder );
	return true;
}

function OnDragLeave( panelId, draggedPanel )
{
	var draggedItem = draggedPanel.data().m_DragItem;
	if ( draggedItem === null || draggedItem == m_Item )
		return false;

	// un-highlight this panel
	$.GetContextPanel().RemoveClass( "potential_drop_target" );
	return true;
}

function OnDragStart( panelId, dragCallbacks )
{
	if ( m_Item == -1 )
	{
		return true;
	}

	var itemName = Abilities.GetAbilityName( m_Item );

	ItemHideTooltip(); // tooltip gets in the way

	// create a temp panel that will be dragged around
	var displayPanel = $.CreatePanel( "DOTAItemImage", $.GetContextPanel(), "dragImage" );
	displayPanel.itemname = itemName;
	displayPanel.contextEntityIndex = m_Item;
	displayPanel.data().m_DragItem = m_Item;
	displayPanel.data().m_DragCompleted = false; // whether the drag was successful

	// hook up the display panel, and specify the panel offset from the cursor
	dragCallbacks.displayPanel = displayPanel;
	dragCallbacks.offsetX = 0;
	dragCallbacks.offsetY = 0;
	
	// grey out the source panel while dragging
	$.GetContextPanel().AddClass( "dragging_from" );
	return true;
}

function OnDragEnd( panelId, draggedPanel )
{
	// if the drag didn't already complete, then try dropping in the world
	if ( !draggedPanel.data().m_DragCompleted )
	{
		Game.DropItemAtCursor( m_QueryUnit, m_Item );
	}

	// kill the display panel
	draggedPanel.DeleteAsync( 0 );

	// restore our look
	$.GetContextPanel().RemoveClass( "dragging_from" );
	return true;
}

function SetItem( queryUnit, iItem )
{
	m_Item = iItem;
	m_QueryUnit = queryUnit;
}

(function()
{
	$.GetContextPanel().data().SetItem = SetItem;

	// Drag and drop handlers ( also requires 'draggable="true"' in your XML, or calling panel.SetDraggable(true) )
	$.RegisterEventHandler( 'DragEnter', $.GetContextPanel(), OnDragEnter );
	$.RegisterEventHandler( 'DragDrop', $.GetContextPanel(), OnDragDrop );
	$.RegisterEventHandler( 'DragLeave', $.GetContextPanel(), OnDragLeave );
	$.RegisterEventHandler( 'DragStart', $.GetContextPanel(), OnDragStart );
	$.RegisterEventHandler( 'DragEnd', $.GetContextPanel(), OnDragEnd );

	UpdateItem(); // initial update of dynamic state
})();
