public with sharing class LeadAsynchronous {
  @future
  public static void updateLeadRecords(Set<Id> existingRecordIds) {
    List<Lead> existingRecords = [
      SELECT Id, LeadSource, Status
      FROM Lead
      WHERE Id IN :existingRecordIds
      WITH SECURITY_ENFORCED
    ];
    for (Lead record : existingRecords) {
      record.LeadSource = 'Dreamforce';
    }
    SObjectAccessDecision decision = Security.stripInaccessible(
      AccessType.UPDATABLE,
      existingRecords
    );
    System.debug(
      'decission.getRecords() : ' + System.JSON.serialize(decision.getRecords())
    );
    update decision.getRecords();
  }

  @future
  public static void createLeadRecords() {
    Lead anotherLead = new Lead(
      FirstName = 'Dreamforce',
      LastName = 'Lead',
      Company = 'Salesforce',
      LeadSource = 'Dreamforce',
      Status = 'Open - Not Contacted'
    );
    SObjectAccessDecision decision = Security.stripInaccessible(
      AccessType.CREATABLE,
      new List<SObject>{ anotherLead }
    );
    insert decision.getRecords();
  }
}

/**
 * Execution
 * Map<Id, Lead> leadRecords = new Map<Id, Lead>([SELECT Id FROM Lead]);
 * LeadAsynchronous.updateLeadRecords(leadRecords.keySet());
 */