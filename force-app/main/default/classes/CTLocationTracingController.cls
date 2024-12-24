public with sharing class CTLocationTracingController {

    public static List<Location_Tracing__c> getVisitors(String locationId){
        // query and return location trace records using locationId
            return [SELECT Id, Name, Person__c, Person__r.Token__c, Person__r.Health_Status__c, Location__c, Visit_Date__c 
                    FROM Location_Tracing__c 
                    WHERE Location__c =: locationId WITH SECURITY_ENFORCED
                    ORDER BY Visit_Date__c NULLS LAST];
        }   

    public static List<Location_Tracing__c> getLocationBypersonIds(Set<id> personIds){
        // query and return location trace records using locationId
            return [SELECT Id, Person__c, Location__c 
                    FROM Location_Tracing__c 
                    WHERE Person__c IN: personIds
                    AND Visit_Date__c = LAST_N_DAYS:10 WITH SECURITY_ENFORCED];
        }  

    public static List<Location_Tracing__c> getLocationByLocationIds(Set<Id> locationIds){
        return [SELECT Id, Person__c, Location__c
                FROM Location_Tracing__c 
                WHERE Location__c IN: locationIds 
                AND Visit_Date__c = LAST_N_DAYS:10
                AND Person__r.Health_Status__c = 'Green' WITH SECURITY_ENFORCED];
    }

    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> newLocationTraces){
        // initialize variables
        Set<Id> personId = new Set<Id>();
        Set<Id> locationId = new Set<Id>();
        List<Location_Tracing__c> existingLocationTraces = new List<Location_Tracing__c>();

        for(Location_Tracing__c locTrac: newLocationTraces){
            personId.add(locTrac.Person__c);
            locationId.add(locTrac.Location__c);
        }

        existingLocationTraces = [SELECT Id, Person__c, Location__c 
                                    FROM Location_Tracing__c 
                                    WHERE Location__c IN: locationId
                                    AND Person__c IN: personId WITH SECURITY_ENFORCED];
                                    
/*         Map<Id, Set<Id>> mapOfExistingRecords = new Map<Id, Set<Id>>();

        if(existingLocationTraces !=null && existingLocationTraces.size() > 0){
        for(Location_Tracing__c locTrac: existingLocationTraces){
                if(!mapOfExistingRecords.containsKey(locTrac.Location__c)){
                    mapOfExistingRecords.put(locTrac.Location__c, new Set<Id>());
                }
                mapOfExistingRecords.get(locTrac.Location__c).add(locTrac.Person__c);
            }

            List<Location_Tracing__c> duplicates = new List<Location_Tracing__c>();

            for(Location_Tracing__c locTrac: newLocationTraces){
                if(mapOfExistingRecords.containsKey(locTrac.Location__c) 
                && mapOfExistingRecords.get(locTrac.Location__c).contains(locTrac.Person__c)){
                    duplicates.add(locTrac);
                }
            }
            return duplicates;
        }else{
            return null;
        } */
        
        // Step 3: Create a Set<String> for quick lookup
        Set<String> existingCombinationSet = new Set<String>();
        for (Location_Tracing__c existingTrace : existingLocationTraces) {
            existingCombinationSet.add(existingTrace.Person__c + '-' + existingTrace.Location__c);
        }

        // Step 4: Check for duplicates in newLocationTraces
        List<Location_Tracing__c> duplicates = new List<Location_Tracing__c>();
        for (Location_Tracing__c newTrace : newLocationTraces) {
            String key = newTrace.Person__c + '-' + newTrace.Location__c;
            if (existingCombinationSet.contains(key)) {
                duplicates.add(newTrace);
            }
        }
        return duplicates;
    }

        /**
     * Get all location ids for visitors
     * @param personIds
     * @return List<Location_Tracing__c>
     */
    public static List<Location_Tracing__c> getLocationsByPersonIds(Set<Id> personIds){
        return [SELECT Id, Person__c, Location__c 
                FROM Location_Tracing__c 
                WHERE Person__c IN :personIds
                AND Visit_Date__c = LAST_N_DAYS:10];
    }
    
}