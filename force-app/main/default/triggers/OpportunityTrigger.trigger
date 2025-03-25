Trigger OpportunityTrigger on Opportunity (before update, before delete) {
    //trigger with logic using Switch statement
    System.TriggerOperation opType = Trigger.operationType;

switch on opType {
    when BEFORE_UPDATE {
        /*
        * Question 5
        * Opportunity Trigger
        * When an opportunity is updated validate that the amount is greater than 5000.
        * Error Message: 'Opportunity amount must be greater than 5000'
        * Trigger should only fire on update.
        */
        for (Opportunity opp : Trigger.new) {
            if (opp.Amount < 5000) {
                opp.addError('Opportunity amount must be greater than 5000');
                }
            }
        
        /*
        * Question 7
        * Opportunity Trigger
        * When an opportunity is updated set the primary contact
        * on the opportunity to the contact on the same account
        * with the title of 'CEO'.
        * Trigger should only fire on update.
        */
            //capture related account Idsof all updated Opportunities 
            Set<Id> acctIds = New Set<Id>();

            for (Opportunity opp : Trigger.new) {
                acctIds.add(opp.AccountId); 
            }
            //find CEO contacts that will be stored as Primary Contact            
            Map <Id,Id> primaryContactMap = new Map <Id,Id>();

            for (Contact con : [SELECT Id, AccountId
                                FROM Contact
                                WHERE Title = 'CEO'
                                AND AccountId IN :acctIds
                                WITH USER_MODE]) {

                primaryContactMap.put(con.AccountId, con.Id);
            }
            //Populate the CEO contact from related Acct
            for (Opportunity opp :Trigger.new) {
                if (opp.AccountId != null && primaryContactMap.containsKey(opp.AccountId)) {
                    opp.Primary_Contact__c = primaryContactMap.get(opp.AccountId);
                }
            }
        } 
    when BEFORE_DELETE {
        /*
        * Question 6
        * Opportunity Trigger
        * When an opportunity is deleted prevent the deletion of a closed won opportunity if the account industry is 'Banking'.
        * Error Message: 'Cannot delete closed opportunity for a banking account that is won'
        * Trigger should only fire on delete.
        */
        Map<Id,Account> accountsWithOppsMap = new Map<Id,Account>([
            SELECT Id, Industry
            FROM Account
            WHERE Id IN (
                SELECT AccountId
                FROM Opportunity
                WHERE Id IN :Trigger.old)
        ]);
        
        for (Opportunity opp : Trigger.old) { 
            if (opp.StageName == 'Closed Won') {
                    String industry = accountsWithOppsMap.get(opp.AccountId).Industry;
                    if(Industry =='Banking'){
                        opp.addError('Cannot delete closed opportunity for a banking account that is won');
                    }
                }
            }
        }
    }
}