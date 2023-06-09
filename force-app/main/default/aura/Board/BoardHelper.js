({
  getWords: function (count) {
    if (count > 100) return;
    let wordsArray = [
      "expansion",
      "grandfather",
      "nappy",
      "oranges",
      "beds",
      "quack",
      "achiever",
      "yell",
      "hospital",
      "winter",
      "understood",
      "squalid",
      "merciful",
      "reaction",
      "wipe",
      "fearless",
      "tiresome",
      "introduce",
      "planes",
      "drum",
      "muddle",
      "capable",
      "canvas",
      "route",
      "enchanted",
      "quirky",
      "switch",
      "apparatus",
      "loss",
      "agreement",
      "substance",
      "back",
      "oafish",
      "expand",
      "aromatic",
      "quarrelsome",
      "free",
      "useful",
      "raspy",
      "drown",
      "ring",
      "lush",
      "numberless",
      "embarrass",
      "shrill",
      "rice",
      "ice",
      "crow",
      "pumped",
      "sparkle",
      "instruct",
      "girl",
      "glass",
      "frog",
      "murky",
      "impolite",
      "crabby",
      "pin",
      "grade",
      "upbeat",
      "linen",
      "flaky",
      "side",
      "unknown",
      "cactus",
      "round",
      "busy",
      "grab",
      "crush",
      "faithful",
      "mother",
      "clean",
      "unhealthy",
      "event",
      "absent",
      "thoughtless",
      "icy",
      "prefer",
      "charge",
      "confuse",
      "clam",
      "dress",
      "snake",
      "evasive",
      "unit",
      "flow",
      "annoying",
      "gusty",
      "possessive",
      "rhetorical",
      "rule",
      "frantic",
      "farm",
      "poor",
      "possess",
      "men",
      "pleasant",
      "zoom",
      "sidewalk",
      "reply"
    ];
    this.randomize(wordsArray);
    return wordsArray.slice(0, count);
  },
  randomize: function (array) {
    let currentIndex = array.length;
    let temporaryValue;
    let randomIndex;
    while (currentIndex !== 0) {
      randomIndex = Math.floor(Math.random() * currentIndex);
      currentIndex -= 1;
      temporaryValue = array[currentIndex];
      array[currentIndex] = array[randomIndex];
      array[randomIndex] = temporaryValue;
    }
  },
  getRamdonWord: function (words) {
    return words[Math.floor(Math.random() * words.length)];
  },
  disableBoard: function (cmp) {
    cmp.set("v.boardDisabled", true);
  },
  enableBoard: function (cmp) {
    cmp.set("v.boardDisabled", false);
  },
  resetBoard: function (cmp) {
    this.enableBoard(cmp);
    cmp.set("v.clickCount", 0);
    cmp.set("v.result", "");
  },
  fireResultEvent: function (result) {
    const resultEvent = $A.get("e.c:ResultApplicationEvent");
    resultEvent.setParams({ result: result });
    resultEvent.fire();
  }
})
