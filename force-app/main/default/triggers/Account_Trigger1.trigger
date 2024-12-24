trigger Account_Trigger1 on Account (after insert) {

    User u = [SELECT id FROM User WHERE Alias = 'Tom'];
    List<AccountTeamMember> listATM = new List<AccountTeamMember>();
    for(Account a: trigger.new)
        {
            if(a.ownership == 'Private')
            {
            AccountTeamMember atm = new AccountTeamMember();
            atm.AccountId = a.id;
            atm.UserId = u.id;
            atm.TeamMemberRole  = 'Account Manager';
            atm.AccountAccessLevel = 'Read';
            listATM.add(atm);
            }
        }
    if(listATM.size() != null)
    insert listATM;
}