@isTest
public with sharing class ContactTriggerHandlerTest {
  @TestSetup
  public static void makeData() {
    List<Account> testAccount = new List<Account>();
    testAccount.add(new Account(Name = 'Test Account 1'));
    testAccount.add(new Account(Name = 'Test Account 2'));

    insert testAccount;
  }

  @isTest
  public static void afterInsertHandlerTest() {
    List<Account> accounts = [SELECT Id, Active_Contacts__c FROM Account];
    List<Contact> testContact = new List<Contact>();
    testContact.add(
      new Contact(
        LastName = 'Test Contact 1',
        AccountId = accounts[0].Id,
        Active__c = true
      )
    );
    testContact.add(
      new Contact(
        LastName = 'Test Contact 2',
        AccountId = accounts[1].Id,
        Active__c = true
      )
    );
    testContact.add(
      new Contact(
        LastName = 'Test Contact 3',
        AccountId = accounts[0].Id,
        Active__c = true
      )
    );
    testContact.add(
      new Contact(
        LastName = 'Test Contact 4',
        AccountId = accounts[1].Id,
        Active__c = true
      )
    );
    testContact.add(
      new Contact(
        LastName = 'Test Contact 5',
        AccountId = accounts[0].Id,
        Active__c = true
      )
    );

    Test.startTest();
    insert testContact;
    Test.stopTest();

    List<Account> accounts2 = [SELECT Id, Active_Contacts__c FROM Account];
    System.assertEquals(3, accounts2[0].Active_Contacts__c, 'Fail');
    System.assertEquals(2, accounts2[1].Active_Contacts__c, 'Fail');
  }

  @isTest
  public static void afterInsertHandlerTestBulk() {
    List<Account> testAccounts = [
      SELECT Id, Name, Active_Contacts__c
      FROM Account
    ];

    List<Contact> testContacts = new List<Contact>();
    for (Integer i = 0; i < 1000; i++) {
      testContacts.add(
        new Contact(
          LastName = 'Test Contact ' + i,
          AccountId = testAccounts[0].Id,
          Active__c = true
        )
      );
    }
    testContacts.add(
      new Contact(
        LastName = 'Test Contact Inactive 1',
        AccountId = testAccounts[0].Id
      )
    );
    testContacts.add(
      new Contact(
        LastName = 'Test Contact Inactive 2',
        AccountId = testAccounts[0].Id
      )
    );
    testContacts.add(
      new Contact(
        LastName = 'Test Contact Inactive 3',
        AccountId = testAccounts[1].Id
      )
    );

    Test.startTest();
    insert testContacts;
    Test.stopTest();

    List<Account> accs = [SELECT Id, Name, Active_Contacts__c FROM Account];

    for (Account acc : accs) {
      if (acc.Name == 'Test Account 1') {
        System.assertEquals(1000, acc.Active_Contacts__c, 'failed');
      }
      if (acc.Name == 'Test Account 2') {
        System.assertEquals(0, acc.Active_Contacts__c, 'failed');
      }
    }

    List<Contact> allContacts = [SELECT Id FROM Contact];
    System.assertEquals(1003, allContacts.size(), 'Failed');
  }

  @isTest
  public static void afterUpdateHandlerTest() {
    List<Account> testAccounts = [
      SELECT Id, Name, Active_Contacts__c
      FROM Account
    ];
    List<Contact> testContacts = new List<Contact>();
    testContacts.add(
      new Contact(
        LastName = 'Test Contact Inactive 1',
        AccountId = testAccounts[0].Id
      )
    );
    testContacts.add(
      new Contact(
        LastName = 'Test Contact Inactive 2',
        AccountId = testAccounts[0].Id
      )
    );
    testContacts.add(
      new Contact(
        LastName = 'Test Contact Inactive 3',
        AccountId = testAccounts[1].Id
      )
    );
    insert testContacts;

    List<Contact> testContacts2 = [SELECT Id FROM Contact];
    for (Contact con : testContacts2) {
      con.Active__c = true;
      con.AccountId = testAccounts[0].Id;
    }
    Test.startTest();
    update testContacts2;
    Test.stopTest();

    List<Account> accs = [SELECT Id, Name, Active_Contacts__c FROM Account];
    System.assertEquals(3, accs[0].Active_Contacts__c, 'failed');
    System.assertEquals(0, accs[1].Active_Contacts__c, 'failed');
  }

  @isTest
  public static void afterDeleteHandlerTest() {
    List<Account> accounts = [
      SELECT Id, Name, Active_Contacts__c
      FROM Account
    ];
    List<Contact> testContacts = new List<Contact>();
    testContacts.add(
      new Contact(
        LastName = 'Test Contact 1',
        AccountId = accounts[0].Id,
        Active__c = true
      )
    );
    testContacts.add(
      new Contact(
        LastName = 'Test Contact 2',
        AccountId = accounts[1].Id,
        Active__c = true
      )
    );
    insert testContacts;

    List<Contact> allContacts = [
      SELECT Id, LastName
      FROM Contact
      WHERE LastName IN ('Test Contact 1', 'Test Contact 2')
    ];
    System.assertEquals(2, allContacts.size(), 'failed');
    Test.startTest();
    delete allContacts;
    Test.stopTest();

    List<Contact> contacts0 = [
      SELECT Id, LastName
      FROM Contact
      WHERE LastName IN ('Test Contact 1', 'Test Contact 2')
    ];
    System.assertEquals(0, contacts0.size(), 'failed');

    List<Account> allAccounts = [
      SELECT Id, Name, Active_Contacts__c
      FROM Account
    ];
    for (Account acc : allAccounts) {
      if (acc.Name == 'Test Account 1') {
        System.assertEquals(0, acc.Active_Contacts__c, 'failed');
      }
      if (acc.Name == 'Test Account 2') {
        System.assertEquals(0, acc.Active_Contacts__c, 'failed');
      }
    }

    allContacts = [SELECT Id, LastName FROM Contact];
    System.assertEquals(0, allContacts.size(), 'failed');
  }

  @isTest
  public static void afterUnDeleteHandlerTest() {
    List<Account> accounts = [
      SELECT Id, Name, Active_Contacts__c
      FROM Account
    ];
    List<Contact> testContacts = new List<Contact>();
    testContacts.add(
      new Contact(
        LastName = 'Test Contact 1',
        AccountId = accounts[0].Id,
        Active__c = true
      )
    );
    testContacts.add(
      new Contact(
        LastName = 'Test Contact 2',
        AccountId = accounts[1].Id,
        Active__c = true
      )
    );
    insert testContacts;

    List<Contact> contactsToDelete = [
      SELECT Id, LastName
      FROM Contact
      WHERE LastName IN ('Test Contact 1', 'Test Contact 2')
    ];
    delete contactsToDelete;

    Test.startTest();
    undelete contactsToDelete;
    Test.stopTest();

    List<Account> allAccounts = [
      SELECT Id, Name, Active_Contacts__c
      FROM Account
    ];
    for (Account acc : allAccounts) {
      if (acc.Name == 'Test Account 1') {
        System.assertEquals(1, acc.Active_Contacts__c, 'failed');
      }
      if (acc.Name == 'Test Account 2') {
        System.assertEquals(1, acc.Active_Contacts__c, 'failed');
      }
    }

    List<Contact> allContacts = [SELECT Id, LastName FROM Contact];
    System.assertEquals(2, allContacts.size(), 'failed');
  }
}
