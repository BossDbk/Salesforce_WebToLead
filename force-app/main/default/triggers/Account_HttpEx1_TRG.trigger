trigger Account_HttpEx1_TRG on Account (after insert) {
    Map<Id,Account> accMap = Trigger.newMap;
    Set<ID> keys = accMap.keySet();
    FM_HttpEx1.invoke(keys);    
}