class ItemSim {
    // Instance variables
    panel: Panel;
    itemImage: ImagePanel;
    itemLabel: LabelPanel;
    costLabel: Panel;

    constructor(parent: Panel, itemName: string, playerName: string) {
        // Create new panel
        const panel = $.CreatePanel("Panel", parent, "");
        this.panel = panel;

        // Load snippet into panel
        panel.BLoadLayoutSnippet("ItemSim");

        // Find components
        this.itemImage = panel.FindChildTraverse("ItemImage") as ImagePanel;
        this.itemLabel = panel.FindChildTraverse("itemname") as LabelPanel;
        this.costLabel = panel.FindChildTraverse("honkaicost")!;

        // Set player name label
        this.itemLabel.text = playerName;

        // Set hero image
        //this.itemImage.SetImage("s2r://panorama/images/heroes/" + "" + "_png.vtex");
    }
}