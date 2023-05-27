/**
 * CTPeopleTracingController
 * Main class for the People_Tracing object.
 * @author Andrés X. Vargas
 */
public with sharing class CTPeopleTracingController {
  /**
   * Retrieves a list of traces related to a person.
   * The list includes people tracing records where the person is either Person 1 or Person 2.
   * The traces are sorted in descending order based on the contact date.
   * @param personId The ID of the person to retrieve traces for.
   * @return A list of People_Tracing__c records related to the person.
   */
  public static List<People_Tracing__c> getTraces(String personId) {
    if (String.isBlank(personId)) {
      return new List<People_Tracing__c>();
    }

    return [
      SELECT
        Id,
        Name,
        Contact_Date__c,
        Contact_Type__c,
        Person_1__c,
        Person_2__c,
        Person_1__r.Name,
        Person_1__r.Health_Status__c,
        Person_1__r.Token__c,
        Person_2__r.Name,
        Person_2__r.Health_Status__c,
        Person_2__r.Token__c
      FROM People_Tracing__c
      WHERE Person_1__c = :personId OR Person_2__c = :personId
      WITH SECURITY_ENFORCED
      ORDER BY Contact_Date__c DESC NULLS LAST
    ];
  }

  /**
   * Checks for duplicates among the provided new people tracing records.
   * A duplicate is considered when there is already an existing people tracing record
   * with the same Person 1 and Person 2 combination.
   * @param newPeopleTraces The new people tracing records to check for duplicates.
   * @return A list of People_Tracing__c records that are considered duplicates.
   */
  public static List<People_Tracing__c> checkDuplicates(
    List<People_Tracing__c> newPeopleTraces
  ) {
    List<People_Tracing__c> duplicates = new List<People_Tracing__c>();
    if (newPeopleTraces == null || newPeopleTraces.isEmpty()) {
      return duplicates;
    }
    Set<Id> personIds = new Set<Id>();
    for (People_Tracing__c newPeopleTrace : newPeopleTraces) {
      personIds.add(newPeopleTrace.Person_1__c);
      personIds.add(newPeopleTrace.Person_2__c);
    }

    List<People_Tracing__c> existingPeopleTraces = [
      SELECT
        Id,
        Name,
        Contact_Date__c,
        Contact_Type__c,
        Person_1__c,
        Person_2__c
      FROM People_Tracing__c
      WHERE Person_1__c IN :personIds OR Person_2__c IN :personIds
      WITH SECURITY_ENFORCED
    ];

    Map<Id, Set<Id>> mapOfExistingRecords = new Map<Id, Set<Id>>();
    if (existingPeopleTraces == null || existingPeopleTraces.isEmpty()) {
      return duplicates;
    }

    for (People_Tracing__c existingPeopleTrace : existingPeopleTraces) {
      if (!mapOfExistingRecords.containsKey(existingPeopleTrace.Person_1__c)) {
        mapOfExistingRecords.put(
          existingPeopleTrace.Person_1__c,
          new Set<Id>()
        );
      }
      mapOfExistingRecords.get(existingPeopleTrace.Person_1__c)
        .add(existingPeopleTrace.Person_2__c);
      if (!mapOfExistingRecords.containsKey(existingPeopleTrace.Person_2__c)) {
        mapOfExistingRecords.put(
          existingPeopleTrace.Person_2__c,
          new Set<Id>()
        );
      }
      mapOfExistingRecords.get(existingPeopleTrace.Person_2__c)
        .add(existingPeopleTrace.Person_1__c);
    }

    return getDuplicates(newPeopleTraces, mapOfExistingRecords);
  }

  /**
   * Finds duplicates among the new people traces based on existing records.
   *
   * @param newPeopleTraces   The list of new People_Tracing__c records to check for duplicates.
   * @param mapOfExistingRecords   A map of existing records where the keys are person IDs and the values are sets of related person IDs.
   * @return   A list of People_Tracing__c records that are duplicates based on existing records.
   */
  private static List<People_Tracing__c> getDuplicates(
    List<People_Tracing__c> newPeopleTraces,
    Map<Id, Set<Id>> mapOfExistingRecords
  ) {
    List<People_Tracing__c> duplicates = new List<People_Tracing__c>();
    for (People_Tracing__c newPeopleTrace : newPeopleTraces) {
      if (
        (mapOfExistingRecords.containsKey(newPeopleTrace.Person_1__c) &&
        mapOfExistingRecords.get(newPeopleTrace.Person_1__c)
          .contains(newPeopleTrace.Person_2__c)) ||
        (mapOfExistingRecords.containsKey(newPeopleTrace.Person_2__c) &&
        mapOfExistingRecords.get(newPeopleTrace.Person_2__c)
          .contains(newPeopleTrace.Person_1__c))
      ) {
        duplicates.add(newPeopleTrace);
      }
    }
    return duplicates;
  }
}
