/**
 * CTPersonController
 * Main controller class for Person__c object.
 * @author Andrés X. Vargas
 */
public with sharing class CTPersonController {
  /**
   * Generates a token based on the provided mobile number.
   * The token is generated using the MD5 hash algorithm on the mobile number.
   *
   * @param mobile The mobile number to generate the token for.
   * @return The generated token as a base64-encoded string.
   */
  public static String getToken(String mobile) {
    Blob targetBlob = Blob.valueOf(mobile);
    Blob hash = Crypto.generateDigest('MD5', targetBlob);

    return EncodingUtil.base64Encode(hash);
  }

  /**
   * Retrieves a list of the most recent health changes for persons.
   * The list is sorted in descending order based on the status update date
   * and limited to a maximum of 100 records.
   *
   * @return A list of Person__c records representing recent health changes.
   */
  public static List<Person__c> getRecentHealthChanges() {
    return [
      SELECT
        Id,
        Name,
        Health_Status__c,
        Mobile__c,
        Status_Update_Date__c,
        Token__c
      FROM Person__c
      WITH SECURITY_ENFORCED
      ORDER BY Status_Update_Date__c DESC NULLS LAST
      LIMIT 100
    ];
  }

  /**
   * Searches for people based on the provided search term.
   * The search is performed using a LIKE operator on the Name field.
   *
   * @param searchTerm The search term to use for searching.
   * @return A list of Person__c records matching the search term.
   */
  public static List<Person__c> searchPeople(String searchTerm) {
    searchTerm = '%' + searchTerm + '%';
    return [
      SELECT
        Id,
        Name,
        Health_Status__c,
        Mobile__c,
        Status_Update_Date__c,
        Token__c
      FROM Person__c
      WHERE
        Name LIKE :searchTerm
        OR Mobile__c LIKE :searchTerm
        OR Token__c LIKE :searchTerm
      WITH SECURITY_ENFORCED
    ];
  }

  /**
   * Retrieves a person by their ID.
   *
   * @param personId The ID of the person to retrieve.
   * @return The Person__c record matching the provided ID.
   */
  public static Person__c getPersonById(String personId) {
    List<Person__c> people = [
      SELECT
        Id,
        Name,
        Health_Status__c,
        Mobile__c,
        Status_Update_Date__c,
        Token__c
      FROM Person__c
      WHERE Id = :personId
      WITH SECURITY_ENFORCED
    ];

    if (people != null && !people.isEmpty()) {
      return people[0];
    }
    return null;
  }

  /**
   * Retrieves the count of persons grouped by health status.
   * The count is represented as a map with health status as the key and the count as the value.
   *
   * @return A map containing the health status count.
   */
  public static Map<String, Integer> getHealthStatusCount() {
    Map<String, Integer> healthStatusCount = new Map<String, Integer>();

    for (AggregateResult result : [
      SELECT Health_Status__c, COUNT(Id) totalCount
      FROM Person__c
      WITH SECURITY_ENFORCED
      GROUP BY Health_Status__c
    ]) {
      healthStatusCount.put(
        (String) result.get('Health_Status__c'),
        (Integer) result.get('totalCount')
      );
    }

    return healthStatusCount;
  }
}
