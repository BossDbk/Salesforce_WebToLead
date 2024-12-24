public with sharing class CTLocationController {

    public static List<Location__c> getRecentStatusChanges(){
        return [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
                FROM Location__c WITH SECURITY_ENFORCED
                ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
    }

    public static List<Location__c> serachLocation(String searchTerm){
        searchTerm = searchTerm + '%';
        return [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c
                FROM Location__c 
                WHERE Name =: searchTerm 
                OR Pincode__c =: searchTerm 
                OR Address__c =: searchTerm WITH SECURITY_ENFORCED
                ORDER BY Status_Update_Date__c DESC NULLS LAST];
    }

    public static Location__c getLocationById(String locationId){
        List<Location__c> locations = [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
                                        FROM Location__c 
                                        WHERE Id =: locationId WITH SECURITY_ENFORCED];
        if (locations != null && locations.size()>0){
            return locations[0];
        }
        return null;

    }

    public static Map<String, Integer> getStatusCount(){
        Map<String, Integer> mapOfLocations = new Map<String, Integer>();
        for(AggregateResult ar : [SELECT  Status__c Status, COUNT(Id) Total
                                    FROM Location__c 
                                    WITH SECURITY_ENFORCED
                                    GROUP BY Status__c]){
            String status = String.valueOf(ar.get('Status'));
            Integer count = Integer.valueOf(ar.get('Total'));
            mapOfLocations.put(status, count);
        }
        return mapOfLocations;
    }

    public static void updateRedScore(Set<Id> locationIds){
        List<Location__c> locationToUpdate = new List<Location__c>();
        AggregateResult[] redPeoplePerLocation = [SELECT Location__c, COUNT(Id) total FROM Location_Tracing__c
                                                    WHERE Person__r.Health_Status__c = 'Red'
                                                    AND Visit_Date__c = LAST_N_DAYS :10
                                                    AND Location__c IN : locationIds WITH SECURITY_ENFORCED 
                                                    GROUP BY Location__c];

                for (AggregateResult ar : redPeoplePerLocation) {
                    String locationId = String.valueOf(ar.get('Location__c'));
                    Integer redScore = Integer.valueOf(ar.get('total'));
                    String status = '';
                        if(redScore == 0){
                            status = 'Green';
                        } else if(redScore <= 5){
                            status = 'Yellow';
                        } else if(redScore <= 10){
                            status = 'Orange';
                        } else{
                            status = 'Red';
                        }
                    locationToUpdate.add(new Location__c(Id=locationId, Red_Score__c=redScore, Status__c=status));
                }
            
                // Update Locations if the field is updateable
                if (!locationToUpdate.isEmpty() && Schema.sObjectType.Location__c.fields.Red_Score__c.isUpdateable()) {
                    try {
                        update locationToUpdate;
                    } catch (DmlException e) {
                        System.debug('Error updating Locations: ' + e.getMessage() + '. Location IDs: ' + locationToUpdate);
                    }
                }
    }
}
