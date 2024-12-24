@IsTest
public with sharing class PublishPlatformEventCallbackTest {
    @IsTest
    public static void testFailedEvent(){
        List<Account_Detail__e> acctDetail = new List<Account_Detail__e>();
        acctDetail.add(new Account_Detail__e(Account_Id__c = 'Red',ActiveOrNot__c = true));
        acctDetail.add(new Account_Detail__e(Account_Id__c = 'Yellow',ActiveOrNot__c = false));

        PublishPlatformEventCallback pubPECallback = new PublishPlatformEventCallback();
        List<Database.SaveResult> saveResultList = EventBus.publish(acctDetail, pubPECallback);

        Test.getEventBus().fail();
        List<Task> tList = [SELECT Id, Subject, Description FROM Task WHERE Subject = 'Failed to publish event'];
        System.Assert.areEqual(1, tList.size(), ' Task not created');
    }
    @IsTest
    static void testSuccessEvent(){
        List<Account_Detail__e> acctDetail = new List<Account_Detail__e>();
        acctDetail.add(new Account_Detail__e(Account_Id__c = 'Red',ActiveOrNot__c = true));
        acctDetail.add(new Account_Detail__e(Account_Id__c = 'Yellow',ActiveOrNot__c = false));

        PublishPlatformEventCallback pubPECallback = new PublishPlatformEventCallback();
        Test.startTest();
        List<Database.SaveResult> saveResultList = EventBus.publish(acctDetail, pubPECallback);
        Test.stopTest();

        List<Task> tList = [SELECT Id, Subject, Description FROM Task WHERE Subject = 'Successfully published event'];
        System.Assert.areEqual(1, tList.size(), 'Task not created');
    }
}