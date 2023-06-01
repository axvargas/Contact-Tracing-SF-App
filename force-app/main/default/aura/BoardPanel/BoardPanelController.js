({
  handleStartNewGame: function (cmp, event) {
    // let gameMode = cmp.find("cmbGameMode").get("v.value");
    // cmp.set("v.selectedGameMode", gameMode);
    console.log(`New Game in ${cmp.get("v.selectedGameMode")}`);
  },
  handleReshuffle: function (cmp, event) {
    console.log("Reshuffle");
  }
});
