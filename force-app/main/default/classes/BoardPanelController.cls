public with sharing class BoardPanelController {
  @AuraEnabled
  public static String addResult(String result, String gameMode) {
    try {
      Word_Shuffle__c ws = new Word_Shuffle__c(
        Result__c = result,
        Game_Mode__c = gameMode
      );
      insert ws;
      return 'success';
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
      return 'error';
    }
  }
}
