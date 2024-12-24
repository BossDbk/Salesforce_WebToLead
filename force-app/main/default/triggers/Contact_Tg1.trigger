trigger Contact_Tg1 on Contact (after insert, after update, after delete, after undelete) {
    switch on Trigger.operationType {
        when AFTER_INSERT {
            ContactTriggerHandler.conAfterInsert(Trigger.new);
        }
        when AFTER_UPDATE {
            ContactTriggerHandler.conAfterUpdate(Trigger.new, Trigger.oldMap);
        }
        when AFTER_DELETE {
            ContactTriggerHandler.conAfterDelete(Trigger.old);
        }
        when AFTER_UNDELETE {
            ContactTriggerHandler.conUndelete(Trigger.new);
        } 
    }
}