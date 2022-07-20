"use strict";
function AddDebugQuest() {
    var panel = $.CreatePanel("Panel", $("#ItemsList"), "");
    panel.BLoadLayoutSnippet("ItemSym");
}
function debug() {
    AddDebugQuest();
}
debug();
