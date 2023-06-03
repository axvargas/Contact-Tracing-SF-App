({
  onBlockClickHandler: function (cmp, event, helper) {
    console.log("BlockController.onBlockClickHandler");
    const open = cmp.get("v.open");
    console.log("open", open);
    if (!open) {
      cmp.set("v.open", true);

      // * Get label value
      const label = cmp.get("v.label");

      // * Fire The onBlockClick event
      const blockClickEvent = cmp.getEvent("onBlockClick");
      blockClickEvent.setParams({
        value: label
      });
      blockClickEvent.fire();
    }
  },
  scriptsLoaded: function (cmp, event, helper) {
    const divElement = cmp.getElement(".board-block");
    fitText(divElement);
  }
})
