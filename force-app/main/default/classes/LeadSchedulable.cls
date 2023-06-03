public with sharing class LeadSchedulable implements Schedulable {
  public void execute(SchedulableContext sc) {
    List<Lead> existingRecords = [
      SELECT Id, LeadSource, Status
      FROM Lead
      WITH SECURITY_ENFORCED
    ];
    for (Lead record : existingRecords) {
      record.LeadSource = 'Dreamforce Scheduled';
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
}
/**
 * LeadSchedulable leadSchedulableInstance = new LeadSchedulable();
 * String cronExpr = '00 30 3 ? * MON';
 * System.schedule('Sample Job', cronExpr, leadSchedulableInstance);
 */
