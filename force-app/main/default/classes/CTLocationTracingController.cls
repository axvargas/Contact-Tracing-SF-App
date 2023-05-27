/**
 * CTLocationTracingController
 * Main class for the Location_Tracing__c object.
 * @author Andrés X. Vargas
 */
public with sharing class CTLocationTracingController {
  /**
   * Retrieves a list of visitors for a specific location.
   * The list is sorted in descending order based on the visit date.
   *
   * @param locationId The ID of the location to retrieve visitors for.
   * @return A list of Location_Tracing__c records representing the visitors of the location.
   */
  public static List<Location_Tracing__c> getVisitors(String locationId) {
    if (String.isBlank(locationId)) {
      return new List<Location_Tracing__c>();
    }

    return [
      SELECT
        Id,
        Name,
        Person__c,
        Location__c,
        Visit_Date__c,
        Person__r.Name,
        Person__r.Health_Status__c
      FROM Location_Tracing__c
      WHERE Location__c = :locationId
      WITH SECURITY_ENFORCED
      ORDER BY Visit_Date__c DESC NULLS LAST
    ];
  }

  /**
   * Retrieves a list of locations visited by persons within the last 10 days.
   * The list is sorted in descending order based on the visit date.
   *
   * @param personIds A set of person IDs to retrieve locations for.
   * @return A list of Location_Tracing__c records representing the visited locations.
   */
  public static List<Location_Tracing__c> getLocationsByPersonIds(
    Set<Id> personIds
  ) {
    if (personIds == null || personIds.isEmpty()) {
      return new List<Location_Tracing__c>();
    }
    return [
      SELECT
        Id,
        Name,
        Person__c,
        Location__c,
        Visit_Date__c,
        Person__r.Name,
        Person__r.Health_Status__c
      FROM Location_Tracing__c
      WHERE Person__c IN :personIds AND Visit_Date__c = LAST_N_DAYS:10
      WITH SECURITY_ENFORCED
      ORDER BY Visit_Date__c DESC NULLS LAST
    ];
  }

  /**
   * Retrieves a list of locations based on the provided location IDs.
   * The list includes locations visited within the last 10 days by persons with a health status of 'Green'.
   * The list is sorted in descending order based on the visit date.
   *
   * @param locationIds A set of location IDs to retrieve locations for.
   * @return A list of Location_Tracing__c records representing the matching locations.
   */
  public static List<Location_Tracing__c> getLocationsByLocationIds(
    Set<Id> locationIds
  ) {
    if (locationIds == null || locationIds.isEmpty()) {
      return new List<Location_Tracing__c>();
    }

    return [
      SELECT
        Id,
        Name,
        Person__c,
        Location__c,
        Visit_Date__c,
        Person__r.Name,
        Person__r.Health_Status__c
      FROM Location_Tracing__c
      WHERE
        Location__c IN :locationIds
        AND Visit_Date__c = LAST_N_DAYS:10
        AND Person__r.Health_Status__c = 'Green'
      WITH SECURITY_ENFORCED
      ORDER BY Visit_Date__c DESC NULLS LAST
    ];
  }

  /**
   * Checks for duplicate Location_Tracing__c records in the provided list of newLocationTraces.
   * A Location_Tracing__c record is considered a duplicate if another record already exists
   * with the same Location__c or Person__c value.
   *
   * @param newLocationTraces The list of new Location_Tracing__c records to check for duplicates.
   * @return A list of Location_Tracing__c records that are duplicates.
   */
  public static List<Location_Tracing__c> checkDuplicates(
    List<Location_Tracing__c> newLocationTraces
  ) {
    List<Location_Tracing__c> duplicates = new List<Location_Tracing__c>();

    if (newLocationTraces == null || newLocationTraces.isEmpty()) {
      return duplicates;
    }

    Set<Id> locationIds = new Set<Id>();
    Set<Id> personIds = new Set<Id>();
    for (Location_Tracing__c locationTrace : newLocationTraces) {
      locationIds.add(locationTrace.Location__c);
      personIds.add(locationTrace.Person__c);
    }

    List<Location_Tracing__c> existingLocationTraces = [
      SELECT Id, Person__c, Location__c
      FROM Location_Tracing__c
      WHERE Location__c IN :locationIds OR Person__c IN :personIds
      WITH SECURITY_ENFORCED
    ];

    Map<Id, Set<Id>> locationPersonMap = new Map<Id, Set<Id>>();
    if (existingLocationTraces == null || existingLocationTraces.isEmpty()) {
      return duplicates;
    }
    for (Location_Tracing__c locationTrace : existingLocationTraces) {
      if (!locationPersonMap.containsKey(locationTrace.Location__c)) {
        locationPersonMap.put(locationTrace.Location__c, new Set<Id>());
      }
      locationPersonMap.get(locationTrace.Location__c)
        .add(locationTrace.Person__c);
    }

    for (Location_Tracing__c locationTrace : newLocationTraces) {
      if (
        locationPersonMap.containsKey(locationTrace.Location__c) &&
        locationPersonMap.get(locationTrace.Location__c)
          .contains(locationTrace.Person__c)
      ) {
        duplicates.add(locationTrace);
      }
    }
    return duplicates;
  }
}
