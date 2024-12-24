public with sharing class PublishPlatformEventCallback implements EventBus.EventPublishSuccessCallback, EventBus.EventPublishFailureCallback {

    public void onSuccess(EventBus.SuccessResult result){
        List<String> eventUUIDList = result.getEventUuids();
        insertTask(eventUUIDList, true);
    } 

    public void onFailure(EventBus.FailureResult result) {
        List<String> eventUUIDList = result.getEventUuids();
        insertTask(eventUUIDList, false);
    }

    public void insertTask(List<String> eventUUIDList, Boolean status) {
        String eventUUIDStr = '';
        Task tsk = new Task();
        for(String eventUUID: eventUUIDList){
            eventUUIDStr += eventUUID + ',';
        }
        if(status){
            tsk.Subject = 'Successfully published event';
            tsk.Description = 'Events successfully published'+ eventUUIDStr;
        } else {
            tsk.Subject = 'Failed to publish event';
            tsk.Description = 'Events failed to be published'+ eventUUIDStr;
        }
        tsk.Status = 'Completed';
        tsk.ActivityDate = Date.today();
        User myUserinfo = [SELECT id FROM User WHERE username = 'bdhanalakota@gmail.com'  WITH SECURITY_ENFORCED];

        if(myUserinfo.id != null){
            tsk.OwnerId = myUserinfo.id;
        }
        try{
            insert tsk;
        } catch (Exception e) {
            System.debug('Error while creating task: ' + e.getMessage());
        }

    }
}