public with sharing class AccountController {
  public static List<Account> getActiveAccounts() {
    return [
      SELECT Id, Name, Phone, Active__c
      FROM Account
      WHERE Active__c = 'Yes'
    ];
  }

  public static List<Account> getAllAccounts() {
    return [SELECT Id, Name, Phone, Active__c FROM Account];
  }

  public static List<Account> printAllAcounts() {
    List<Account> accounts = getAllAccounts();
    for (Account acc : accounts) {
      System.debug('Name: ' + acc.name + ', Phone: ' + acc.Phone);
    }
    return accounts;
  }

  public static List<Account> insertAccounts(List<Account> accountsToInsert) {
    insert accountsToInsert;
    return accountsToInsert;
  }

  public static Account insertAccount(Account accountToInsert) {
    insert accountToInsert;
    return accountToInsert;
  }

  public static Integer getAccountSize() {
    List<Account> accounts = getAllAccounts();
    return accounts.size();
  }

  public static void updateAvgCaseResolutionDays(List<Id> accountIds) {
    Map<Id, Integer> accountWithTotalCaseMap = new Map<Id, Integer>();
    Map<Id, Integer> accountWithTotalCaseDaysMap = new Map<Id, Integer>();

    // retrive all the cases for all accounts
    for (Case caseObj : [
      SELECT Id, CreatedDate, ClosedDate, AccountId
      FROM Case
      WHERE IsClosed = TRUE AND AccountId IN :accountIds
    ]) {
      Id accId = caseObj.AccountId;
      if (!accountWithTotalCaseMap.containsKey(accId)) {
        accountWithTotalCaseMap.put(accId, 0);
        accountWithTotalCaseDaysMap.put(accId, 0);
      }
      // increase number of cases
      Integer totalCases = accountWithTotalCaseMap.get(accId);
      totalCases++;
      accountWithTotalCaseMap.put(accId, totalCases);

      // get duration in days and add it to totalDays
      Integer totalDays = accountWithTotalCaseDaysMap.get(accId);
      totalDays += caseObj.ClosedDate.date()
        .daysBetween(caseObj.CreatedDate.date());
      accountWithTotalCaseDaysMap.put(accId, totalDays);
    }

    // list of accounts to update
    List<Account> accountToUpdate = new List<Account>();
    for (Id accId : accountWithTotalCaseMap.keySet()) {
      Integer totalCases = accountWithTotalCaseMap.get(accId);
      Integer totalDays = accountWithTotalCaseDaysMap.get(accId);

      Decimal resolutionDays = totalDays / totalCases;
      // update account object
      accountToUpdate.add(
        new Account(Id = accId, Avg_Case_Resolution_Days__c = resolutionDays)
      );
    }
    update accountToUpdate;
  }
}
