({
  addResultRecord: function (cmp, gameResult) {
    // Create Apex method call action
    const action = cmp.get("c.addResult");
    // Set the parameters
    action.setParams({
      result: gameResult.toUpperCase(),
      gameMode: cmp.get("v.selectedGameMode").toUpperCase()
    });
    // Set the callback
    action.setCallback(this, function (response) {
      const state = response.getState();
      if (state === "SUCCESS") {
        console.log("Success");
      } else {
        console.log("Failed");
      }
    });
    // Enqueue the action
    $A.enqueueAction(action);
  },
  showToast: function (title, msg, type) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      "title": title,
      "message": msg,
      "type": type
    });
    toastEvent.fire();
  }
})
