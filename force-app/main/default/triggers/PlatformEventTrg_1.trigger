trigger PlatformEventTrg_1 on Account_Detail__e (after insert) {
    switch on Trigger.operationType {
        when AFTER_INSERT {
            PlatformEventTrgHandler.afterInsert(Trigger.new);
        }
    }
}