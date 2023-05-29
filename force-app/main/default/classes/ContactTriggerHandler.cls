public with sharing class ContactTriggerHandler {
  public static void afterInsertHandler(List<Contact> newRecords) {
    Set<Id> accountIds = new Set<Id>();
    for (Contact contactRecord : newRecords) {
      if (!String.isBlank(contactRecord.AccountId)) {
        accountIds.add(contactRecord.AccountId);
      }
    }
    AccountContactService.updateActiveContactsCounts(accountIds);
  }

  public static void afterUpdateHandler(
    List<Contact> newRecords,
    Map<Id, Contact> oldRecordMap
  ) {
    Set<Id> accountIds = new Set<Id>();
    for (Contact contactRecord : newRecords) {
      if (
        !String.isBlank(contactRecord.AccountId) &&
        (oldRecordMap.get(contactRecord.Id).Active__c !=
        contactRecord.Active__c)
      ) {
        accountIds.add(contactRecord.AccountId);
      }
      if (
        !String.isBlank(contactRecord.AccountId) &&
        (oldRecordMap.get(contactRecord.Id).AccountId !=
        contactRecord.AccountId)
      ) {
        accountIds.add(contactRecord.AccountId);
        accountIds.add(oldRecordMap.get(contactRecord.Id).AccountId);
      }
    }
    System.debug('accountIds: ' + accountIds);
    AccountContactService.updateActiveContactsCounts(accountIds);
  }
  public static void afterDeleteHandler(List<Contact> oldRecords) {
    Set<Id> accountIds = new Set<Id>();
    for (Contact contactRecord : oldRecords) {
      if (!String.isBlank(contactRecord.AccountId)) {
        accountIds.add(contactRecord.AccountId);
      }
    }
    AccountContactService.updateActiveContactsCounts(accountIds);
  }
  public static void afterUndeleteHandler(List<Contact> newRecords) {
    Set<Id> accountIds = new Set<Id>();
    for (Contact contactRecord : newRecords) {
      if (!String.isBlank(contactRecord.AccountId)) {
        accountIds.add(contactRecord.AccountId);
      }
    }
    AccountContactService.updateActiveContactsCounts(accountIds);
  }
}
