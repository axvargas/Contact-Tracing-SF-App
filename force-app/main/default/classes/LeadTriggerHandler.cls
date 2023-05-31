public class LeadTriggerHandler {
  public static boolean alreadyExecuted = false;
  public static void beforeInsertHandler(List<Lead> newRecords) {
    for (Lead leadRecord : newRecords) {
      if (String.isBlank(leadRecord.LeadSource)) {
        leadRecord.LeadSource = 'Other';
      }
      if (String.isBlank(leadRecord.Industry)) {
        leadRecord.addError('The Industry field cannot be blank');
      }
    }
  }

  public static void afterInsertHandler(List<Lead> newRecords) {
    List<Task> leadTasks = new List<Task>();
    for (Lead leadRecord : newRecords) {
      // Create a task after creating a lead
      Task leadTask = new Task(
        Subject = 'Follow up on Lead Status',
        WhoId = leadRecord.Id
      );
      leadTasks.add(leadTask);
    }
    insert leadTasks;

    // Insert another lead record
    if (LeadTriggerHandler.alreadyExecuted == false) {
      LeadTriggerHandler.alreadyExecuted = true;
      Lead anotherLead = new Lead(
        LastName = 'Teast Lead another',
        Status = 'Open - Not Contacted',
        Company = 'SFDCFacts',
        Industry = 'Finance'
      );
      insert anotherLead;
    }
  }
  public static void beforeUpdateHandler(
    List<Lead> newRecords,
    Map<Id, Lead> oldMapRecords
  ) {
    for (Lead leadRecord : newRecords) {
      if (String.isBlank(leadRecord.LeadSource)) {
        leadRecord.LeadSource = 'Other';
      }
      if (
        ((leadRecord.Status == 'Closed - Converted') ||
        (leadRecord.Status == 'Closed - Not Converted')) &&
        oldMapRecords.get(leadRecord.Id).Status == 'Open - Not Contacted'
      ) {
        leadRecord.Status.addError(
          'You cannot directly close an open lead record'
        );
      }
    }
  }
}
