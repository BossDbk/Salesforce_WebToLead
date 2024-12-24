public with sharing class PlatformEventTrgHandler {

    public static void afterInsert(List<Account_Detail__e> newRecords) {
        List<Task> tasksToCreate = new List<Task>();
        User usr = [SELECT Id, Name FROM User WHERE username = 'bdhanalakota@gmail.com'];
        for (Account_Detail__e accDetail : newRecords) {
            if (accDetail.ActiveOrNot__c != null) {
                tasksToCreate.add(new Task(
                    Subject = 'Successfully published event using Trigger' + accDetail.Account_Id__c,
                    Description = 'Event Published using Trigger with Status : ' + accDetail.ActiveOrNot__c,
                    OwnerId = usr.Id,
                    ActivityDate = Date.today()
                    ));
            }
        }
        if (!tasksToCreate.isEmpty()) {
            try {
                insert tasksToCreate;
            } catch (Exception ex) {
                System.debug('Error ' + ex.getMessage());
            }

        }
    }
}