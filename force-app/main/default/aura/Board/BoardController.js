({
  doInit: function (cmp, event, helper) {
    console.log("BoardController.doInit");

    // get the game mode
    const gameMode = cmp.get("v.gameMode");
    let numberOfColumns = 0;
    switch (gameMode) {
      case "easy":
        numberOfColumns = 3;
        break;
      case "medium":
        numberOfColumns = 4;
        break;
      case "hard":
        numberOfColumns = 6;
        break;
    }
    //Set block size
    cmp.set("v.blockSize", 12 / numberOfColumns);

    // get the words
    const words = helper.getWords(numberOfColumns ** 2);

    // select a random word
    const randomWord = helper.getRamdonWord(words);

    // set the words and random word
    cmp.set("v.words", null);
    cmp.set("v.words", words);
    cmp.set("v.randomWord", null);
    cmp.set("v.randomWord", randomWord);

    //Reset the board
    helper.resetBoard(cmp);
  },
  doRender: function (cmp, event, helper) {
    console.log("BoardController.doRender");
  },
  handleBlockClick: function (cmp, event, helper) {
    // * Get click count +1
    let clickCount = cmp.get("v.clickCount") + 1;

    // * Get value from event
    const value = event.getParam("value");
    console.log("BoardController.handleBlockClick", value);

    //* Get random word
    const selectedWord = cmp.get("v.randomWord");

    // * Check if the value is equal to the random word
    if (value === selectedWord) {
      console.log("You win!");
      cmp.set("v.result", "YOU WIN!");
      helper.fireResultEvent("win")
      helper.disableBoard(cmp);
    } else if (clickCount === 5) {
      console.log("You lose!");
      cmp.set("v.result", "YOU LOSE!");
      helper.fireResultEvent("lose")
      helper.disableBoard(cmp);
    }
    // * Set click count
    cmp.set("v.clickCount", clickCount);
  },
  reshuffleBoard: function (cmp, event, helper) {
    console.log("BoardController.reshuffleBoard");
    const words = cmp.get("v.words");
    helper.randomize(words);
    console.log("randomizedWords", words);
    cmp.set("v.words", words);
    helper.resetBoard(cmp);
  }
})
