public with sharing class LeadQueueable implements Queueable {
  public void execute(QueueableContext context) {
    List<Lead> existingRecords = [
      SELECT Id, LeadSource
      FROM Lead
      WITH SECURITY_ENFORCED
    ];
    for (Lead record : existingRecords) {
      record.LeadSource = 'Dreamforce queue';
    }
    SObjectAccessDecision decision = Security.stripInaccessible(
      AccessType.UPDATABLE,
      existingRecords
    );
    update decision.getRecords();

    // call another queueable class
  }
}

/**
 * LeadQueueable leadQueueableInstace = new LeadQueueable();
 * ID jobID = System.enqueueJob(leadQueueableInstace);
 * System.debug('jobID: ' + jobID);
 */

