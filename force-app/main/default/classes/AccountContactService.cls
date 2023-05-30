public with sharing class AccountContactService {
  public static Map<Id, Account> countActiveContacts(Set<Id> accountIds) {
    Map<Id, Account> accountsWithInfoMap = new Map<Id, Account>();

    List<AggregateResult> results = [
      SELECT AccountId, COUNT(Id) ActiveContactsCount
      FROM Contact
      WHERE Active__c = TRUE AND AccountId IN :accountIds
      WITH SECURITY_ENFORCED
      GROUP BY AccountId
    ];

    for (AggregateResult result : results) {
      accountsWithInfoMap.put(
        (Id) result.get('AccountId'),
        new Account(
          Id = (Id) result.get('AccountId'),
          Active_Contacts__c = (Integer) result.get('ActiveContactsCount')
        )
      );
    }
    for (Id accountId : accountIds) {
      if (!accountsWithInfoMap.containsKey(accountId)) {
        accountsWithInfoMap.put(
          accountId,
          new Account(Id = accountId, Active_Contacts__c = 0)
        );
      }
    }
    return accountsWithInfoMap;
  }

  public static void updateActiveContactsCounts(Set<Id> accountIds) {
    Map<Id, Account> accountsToUpdateMap = countActiveContacts(accountIds);
    if (accountsToUpdateMap != null && !accountsToUpdateMap.isEmpty()) {
      if (Schema.sObjectType.Account.fields.Active_Contacts__c.isUpdateable()) {
        update accountsToUpdateMap.values();
      }
    }
  }
}
