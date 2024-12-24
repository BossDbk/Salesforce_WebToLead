trigger Contact_Trg on Account (before insert, before update) {
    for (Account acc : Trigger.new) {
        if (acc.Contacts.size() > 2) {
            acc.addError('An account cannot have more than two contacts');
        }
    }
}