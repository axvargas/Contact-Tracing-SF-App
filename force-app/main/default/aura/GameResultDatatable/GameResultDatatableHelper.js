({
  fetchData: function (cmp) {
    const action = cmp.get("c.getResults");
    action.setCallback(this, function (response) {
      const state = response.getState();
      if (state === "SUCCESS") {
        const data = response.getReturnValue();
        cmp.set("v.data", data);
      } else {
        console.log("Failed");
      }
    });
    $A.enqueueAction(action);
  }
})
