public with sharing class ContactAccountService {

    public static void updateAccount(Set<Id> accountIds) {
        if (!accountIds.isEmpty()) { 
                // Aggregate the count of active contacts for each Account
                List<AggregateResult> aggList = [SELECT AccountId, COUNT(Id) TotContacts 
                                                FROM Contact 
                                                WHERE AccountId IN :accountIds AND Active__c = true WITH SECURITY_ENFORCED
                                                GROUP BY AccountId];
        
                List<Account> accUpdate = new List<Account>();
        
                for (AggregateResult result : aggList) {
                    String accId = (String) result.get('AccountId');
                    Integer totCnt = (Integer) result.get('TotContacts');
                    accUpdate.add(new Account(Id = accId, Active_Contacts__c = totCnt));
                }
        
                // Update Accounts if the field is updateable
                if (!accUpdate.isEmpty() && Schema.sObjectType.Account.fields.Active_Contacts__c.isUpdateable()) {
                    try {
                        update accUpdate;
                    } catch (DmlException e) {
                        System.debug('Error updating accounts: ' + e.getMessage() + '. Account IDs: ' + accountIds);
                    }
                }
        } else {
            System.debug('No valid Account IDs found in the updated Contacts.');
        }
    }

}