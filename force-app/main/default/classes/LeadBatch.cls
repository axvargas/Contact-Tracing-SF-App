public with sharing class LeadBatch implements Database.Batchable<SObject> {
  public Database.QueryLocator start(Database.BatchableContext bc) {
    return Database.getQueryLocator('SELECT Id, LeadSource FROM Lead');
  }

  public void execute(Database.BatchableContext BC, list<Lead> scope) {
    for (Lead leadRecord : scope) {
      leadRecord.LeadSource = 'Web';
    }
    update scope;
  }
  public void finish(Database.BatchableContext BC) {
    System.debug('Batch finished!!!');
  }
}

/**
 * LeadBatch leadBatch = new LeadBatch();
 * Database.executeBatch(leadBatch, 10);
 */

