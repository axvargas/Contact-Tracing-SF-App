/**
 * CTLocationController
 * Main class for the Location__c object.
 * @author Andrés X. Vargas
 */
public with sharing class CTLocationController {
  /**
   * Retrieves a list of the most recent status changes for locations.
   * The list is sorted in descending order based on the status update date
   * and limited to a maximum of 100 records.
   *
   * @return A list of Location__c records representing recent status changes.
   */
  public static List<Location__c> getRecentStatusChanges() {
    return [
      SELECT
        Id,
        Name,
        Address__c,
        Pincode__c,
        Red_Score__c,
        Status_Update_Date__c,
        Status__c
      FROM Location__c
      WITH SECURITY_ENFORCED
      ORDER BY Status_Update_Date__c DESC NULLS LAST
      LIMIT 100
    ];
  }

  /**
   * Searches for locations whose name, address, or pincode matches the provided search term.
   * The search is case-insensitive and supports partial matching.
   *
   * @param searchTerm The search term to match against location names, addresses, and pincodes.
   * @return A list of Location__c records matching the search term.
   */
  public static List<Location__c> searchLocations(String searchTerm) {
    searchTerm = '%' + searchTerm + '%';
    return [
      SELECT
        Id,
        Name,
        Address__c,
        Pincode__c,
        Red_Score__c,
        Status_Update_Date__c,
        Status__c
      FROM Location__c
      WHERE
        Name LIKE :searchTerm
        OR Address__c LIKE :searchTerm
        OR Pincode__c LIKE :searchTerm
      WITH SECURITY_ENFORCED
      ORDER BY Status_Update_Date__c DESC NULLS LAST
    ];
  }

  /**
   * Retrieves a location by its ID.
   *
   * @param locationId The ID of the location to retrieve.
   * @return The Location__c record matching the provided location ID.
   */
  public static Location__c getLocationById(String locationId) {
    List<Location__C> locations = [
      SELECT
        Id,
        Name,
        Address__c,
        Pincode__c,
        Red_Score__c,
        Status_Update_Date__c,
        Status__c
      FROM Location__c
      WHERE Id = :locationId
      WITH SECURITY_ENFORCED
    ];
    if (locations != null && !locations.isEmpty()) {
      return locations[0];
    }
    return null;
  }

  /**
   * The `getStatusCount` method retrieves the count of locations for each status.
   * It performs an aggregate query on the `Location__c` object to calculate the total count of locations
   * grouped by the `Status__c` field.
   *
   * @return A map containing the status as the key and the corresponding count as the value.
   */
  public static Map<String, Integer> getStatusCount() {
    Map<String, Integer> statusCount = new Map<String, Integer>();
    for (AggregateResult result : [
      SELECT Status__c, COUNT(Id) totalCount
      FROM Location__c
      WITH SECURITY_ENFORCED
      GROUP BY Status__c
    ]) {
      statusCount.put(
        (String) result.get('Status__c'),
        (Integer) result.get('totalCount')
      );
    }
    return statusCount;
  }
}
