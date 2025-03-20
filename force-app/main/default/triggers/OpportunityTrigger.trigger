trigger OpportunityTrigger on Opportunity (before insert, before update, before delete, after delete) {
    System.debug('Type of trigger that initiated the run is a(n): ' + trigger.operationType);

    If(trigger.isBefore){
        if (trigger.isInsert){
            //placeholder.. may remove
            System.debug('Before insert trigger ran');
        }
        /*
        * Question 5
        * Opportunity Trigger
        * When an opportunity is updated validate that the amount is greater than 5000.
        * Error Message: 'Opportunity amount must be greater than 5000'
        * Trigger should only fire on update.
        */
        if (trigger.isUpdate){
            for(Opportunity opp : trigger.new){
                if(opp.Amount < 5000){
                    opp.addError('Opportunity amount must be greater than 5000');
                }
            }
        }
        /*
        * Question 6
        * Opportunity Trigger
        * When an opportunity is deleted prevent the deletion of a closed won opportunity if the account industry is 'Banking'.
        * Error Message: 'Cannot delete closed opportunity for a banking account that is won'
        * Trigger should only fire on delete.
        */
        if (trigger.isDelete){  
            Map<Id, Opportunity> deletedOpps = new Map<Id, Opportunity>([
                        SELECT Id, StageName, AccountId, Account.Industry
                        FROM Opportunity
                        WHERE Id IN :trigger.oldMap.keySet()
                        WITH USER_MODE
                    ]);
            System.debug('deletedOpps record: ' + deletedOpps);

            for (Opportunity opp : deletedOpps.values()){
                If (opp.AccountId != null){
                    if(opp.StageName == 'Closed Won' &&
                        opp.Account != null &&
                        opp.Account.Industry == 'Banking'){
                        opp.addError('Cannot delete closed opportunity for a banking account that is won');
                    }
                }
            }
        }
        if (trigger.isAfter){
            if (trigger.isDelete){
                //placeholder
                System.debug('An After Trigger ran');
            }
        }
    }
}