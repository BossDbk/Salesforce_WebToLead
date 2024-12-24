public with sharing class PublishPlatformEvent {

    public static void pubPlatformEvent(){
        //1. Create records in "Location Tracing" custom object
        List<Account_Detail__e> acctDetail = new List<Account_Detail__e>();
        acctDetail.add(new Account_Detail__e(Account_Id__c = 'Red',ActiveOrNot__c = true));
        acctDetail.add(new Account_Detail__e(Account_Id__c = 'Yellow',ActiveOrNot__c = false));

        PublishPlatformEventCallback pubPECallback = new PublishPlatformEventCallback();
        List<Database.SaveResult> saveResultList = EventBus.publish(acctDetail, pubPECallback);

        for (Database.SaveResult saveResult : saveResultList) {
            if (saveResult.isSuccess()) {
                System.debug('Successfully published event.');
            } else { 
                for(Database.Error error : saveResult.getErrors()) {
                    System.debug('Error returned: ' + error.getStatusCode() + ' - ' + error.getMessage());
                }
            }
        }
    }
}
