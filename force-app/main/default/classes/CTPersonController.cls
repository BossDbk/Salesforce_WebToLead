public with sharing class CTPersonController {

    public static String getToken(String mobileNo){
        Blob targetBlob = Blob.valueOf(mobileNo);
        Blob hash = Crypto.generateDigest('MD5', targetBlob);
        return EncodingUtil.base64Encode(hash);
    }

    public static List<Person__c> getRecentHealthChanges(){
        return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                FROM Person__c WITH SECURITY_ENFORCED
                ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
    }

    public static List<Person__c> serachPeople(String searchTerm){
        searchTerm = searchTerm + '%';
        return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                FROM Person__c 
                WHERE Name =: searchTerm 
                OR Mobile__c =: searchTerm 
                OR Token__c =: searchTerm WITH SECURITY_ENFORCED
                ORDER BY Status_Update_Date__c DESC NULLS LAST];
    }

    public static Person__c getPersonById(String personId){
        List<Person__c> people = [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                FROM Person__c 
                WHERE Id =: personId WITH SECURITY_ENFORCED];
                if (people != null && people.size()>0){
                    return people[0];
                }
                return null;
            }
            
    public static Map<String, Integer> getHealthStatusCount(){
        Map<String, Integer> mapOfHealthCount = new Map<String, Integer>();
        for(AggregateResult arr : [SELECT Health_Status__c, COUNT(Id) Total 
                                    FROM Person__c WITH SECURITY_ENFORCED 
                                    GROUP BY Health_Status__c]){
            String health = String.valueOf(arr.get('Health_Status__c'));
            Integer count = Integer.valueOf(arr.get('Total'));
            mapOfHealthCount.put(health, count);
        }
        return mapOfHealthCount;
    }

    public static Set<Id> getCohabitants(Set<Id> personIds, Set<Id> alreadyProcessed){
        List<String> healthStatuses = new List<String>{'Green', 'Yellow'};
        List<People_Tracing__c> peopleTraces = [SELECT Id, Person_1__c, Person_2__c FROM People_Tracing__c 
                                                    WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds) 
                                                    AND Contact_Type__c = 'Cohabitant'
                                                    AND (Person_1__r.Health_Status__c IN :healthStatuses OR Person_2__r.Health_Status__c IN : healthStatuses)
                                                    WITH SECURITY_ENFORCED];
        Set<Id> cohabitants = new Set<Id>();
        for(People_Tracing__c pt : peopleTraces){
            if(!alreadyProcessed.contains(pt.Person_1__c)){
                cohabitants.add(pt.Person_1__c);
                alreadyProcessed.add(pt.Person_1__c);
            }
            if(!personIds.contains(pt.Person_2__c)){
                cohabitants.add(pt.Person_2__c);
                alreadyProcessed.add(pt.Person_2__c);
            }
        }
        return cohabitants;

    }

    public static Set<Id> getPrimaryContacts(Set<Id> personIds, Set<Id> alreadyProcessed){
        List<String> healthStatuses = new List<String>{'Green', 'Yellow'};
        List<People_Tracing__c> peopleTraces = [SELECT Id, Person_1__c, Person_2__c FROM People_Tracing__c 
                                                    WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds) 
                                                    AND Contact_Type__c = 'Other'
                                                    AND Contact_Date__c = LAST_N_DAYS:10
                                                    AND (Person_1__r.Health_Status__c IN :healthStatuses OR Person_2__r.Health_Status__c IN :healthStatuses)
                                                    WITH SECURITY_ENFORCED];
        Set<Id> primaryContacts = new Set<Id>();
        for(People_Tracing__c pt : peopleTraces){
            if(!alreadyProcessed.contains(pt.Person_1__c)){
                primaryContacts.add(pt.Person_1__c);
                alreadyProcessed.add(pt.Person_1__c);
            }
            if(!alreadyProcessed.contains(pt.Person_2__c)){
                primaryContacts.add(pt.Person_2__c);
                alreadyProcessed.add(pt.Person_2__c);
            }
        }
        return primaryContacts;
    }

    public static Set<Id> getNeighbours(Set<Id> personIds, Set<Id> alreadyProcessed){
        List<People_Tracing__c> peopleTraces = [SELECT Id, Person_1__c, Person_2__c FROM People_Tracing__c 
                                                    WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds) 
                                                    AND Contact_Type__c = 'Neighbour'
                                                    AND (Person_1__r.Health_Status__c = 'Green' OR Person_2__r.Health_Status__c = 'Green')
                                                    WITH SECURITY_ENFORCED];
        Set<Id> neighbours = new Set<Id>();
        for(People_Tracing__c pt : peopleTraces){
            if(!alreadyProcessed.contains(pt.Person_1__c)){
                neighbours.add(pt.Person_1__c);
                alreadyProcessed.add(pt.Person_1__c);
            }
            if(!alreadyProcessed.contains(pt.Person_2__c)){
                neighbours.add(pt.Person_2__c);
                alreadyProcessed.add(pt.Person_2__c);
            }
        }
        return neighbours;
    }

    public static Set<Id> getSecondaryContacts(Set<Id> primaryContactsIds, Set<Id> alreadyProcessed){
        List<People_Tracing__c> peopleTraces = [SELECT Id, Person_1__c, Person_2__c FROM People_Tracing__c 
                                                    WHERE (Person_1__c IN :primaryContactsIds OR Person_2__c IN :primaryContactsIds) 
                                                    AND Contact_Type__c = 'Other'
                                                    AND Contact_Date__c = LAST_N_DAYS:10
                                                    AND (Person_1__r.Health_Status__c = 'Green' OR Person_2__r.Health_Status__c = 'Green')
                                                    WITH SECURITY_ENFORCED];
        Set<Id> secondaryContacts = new Set<Id>();
        for(People_Tracing__c pt : peopleTraces){
            if(!alreadyProcessed.contains(pt.Person_1__c)){
                secondaryContacts.add(pt.Person_1__c);
                alreadyProcessed.add(pt.Person_1__c);
            }
            if(!alreadyProcessed.contains(pt.Person_2__c)){
                secondaryContacts.add(pt.Person_2__c);
                alreadyProcessed.add(pt.Person_2__c);
            }
        }
        return secondaryContacts;
    }

}