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
      default:
        numberOfColumns = 3;
    }
    //Set block size
    cmp.set("v.blockSize", 12 / numberOfColumns);

    // get the words
    const words = helper.getWords(numberOfColumns ** 2);

    // select a random word
    const randomWord = helper.getRamdonWord(words);

    // set the words and random word
    cmp.set("v.words", words);
    cmp.set("v.randomWord", randomWord);

    // log the words and random word
    console.log('words', words);
    console.log('randomWord', randomWord);
  },
  doRender: function (cmp, event, helper) {
    console.log("BoardController.doRender");
  }
})
