public with sharing class GameResultController {
  @AuraEnabled
  public static List<Word_Shuffle__c> getResults() {
    try {
      String userId = UserInfo.getUserId();
      return [
        SELECT Id, Name,  Game_Mode__c, Result__c, CreatedDate
        FROM Word_Shuffle__c
        WHERE CreatedById = :userId
        WIth SECURITY_ENFORCED
        ORDER BY CreatedDate DESC
      ];
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
