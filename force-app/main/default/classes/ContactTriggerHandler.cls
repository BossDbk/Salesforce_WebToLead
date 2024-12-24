public with sharing class ContactTriggerHandler {
    
    public static void conAfterInsert(List<Contact> newContacts) {
        Set<Id> accIds = new Set<Id>();
    
        // Collect Account IDs from the new Contacts
        for (Contact con : newContacts) {
            if (String.isNotBlank(con.AccountId)) {
                accIds.add(con.AccountId);
            }
        }
    
        ContactAccountService.updateAccount(accIds);
        
    }
    
    public static void conAfterUpdate(List<Contact> newContacts, Map<Id, Contact> oldMap) {
        Set<Id> accIds = new Set<Id>();
    
        // Collect Account IDs from updated Contacts
        for (Contact con : newContacts) {
            if (String.isNotBlank(con.AccountId)) {
                // Check if AccountId has changed
                if (oldMap.get(con.Id).AccountId != con.AccountId) {
                    accIds.add(con.AccountId);
                    if (oldMap.get(con.Id).AccountId != null) {
                        accIds.add(oldMap.get(con.Id).AccountId);
                    }
                }
                // Check if Active__c has changed
                else if (con.Active__c != oldMap.get(con.Id).Active__c) {
                    accIds.add(con.AccountId);
                }
            }
        }
    
        ContactAccountService.updateAccount(accIds);
    }

    public static void conAfterDelete(List<Contact> oldContacts){

        Set<Id> accIds = new Set<Id>();
    
        // Collect Account IDs from the new Contacts
        for (Contact con : oldContacts) {
            if (String.isNotBlank(con.AccountId)) {
                accIds.add(con.AccountId);
            }
        }
    
        ContactAccountService.updateAccount(accIds);
    } 

    public static void conUndelete(List<Contact> newContacts){

        Set<Id> accIds = new Set<Id>();
    
        // Collect Account IDs from the new Contacts
        for (Contact con : newContacts) {
            if (String.isNotBlank(con.AccountId)) {
                accIds.add(con.AccountId);
            }
        }
    
        ContactAccountService.updateAccount(accIds);
    } 
}