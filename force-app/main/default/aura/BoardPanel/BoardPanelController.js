({
  handleStartNewGame: function (cmp, event) {
    let gameMode = cmp.find("cmbGameMode").get("v.value");

    let selectedGameMode = cmp.get("v.selectedGameMode");
    cmp.set("v.selectedGameMode", gameMode);

    if (selectedGameMode) {
      const boardCmp = cmp.find("boardCmp");
      boardCmp.startNewGame();
    }

  },
  handleReshuffle: function (cmp, event) {
    console.log("Reshuffle");
    const boardCmp = cmp.find("boardCmp");
    boardCmp.reshuffleBoard();
    cmp.set("v.reshuffleDisabled", true);
  },
  onResultHandler: function (cmp, event, helper) {
    const result = event.getParam("result");
    console.log("Result: ", result);
    if (result === "win") {
      cmp.set("v.reshuffleDisabled", true);
      helper.showToast("You won!", "You are a marvelous winner", "success");
    } else {
      cmp.set("v.reshuffleDisabled", false);
      helper.showToast("You won!", "You are a f***** loser. Reshuffle the board to keep trying", "error");
    }
    helper.addResultRecord(cmp, result);

  }
});
