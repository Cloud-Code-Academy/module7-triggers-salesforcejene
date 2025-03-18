trigger OpportunityTrigger on Opportunity (before insert, before update, before delete) {
    /*
    * Question 5
    * Opportunity Trigger
    * When an opportunity is updated validate that the amount is greater than 5000.
    * Error Message: 'Opportunity amount must be greater than 5000'
    * Trigger should only fire on update.
    */
    If(trigger.isBefore){
        if (trigger.isInsert){
            System.debug('Before insert trigger ran');
        }

        /*
        * Question 6
        * Opportunity Trigger
        * When an opportunity is deleted prevent the deletion of a closed won opportunity if the account industry is 'Banking'.
        * Error Message: 'Cannot delete closed opportunity for a banking account that is won'
        * Trigger should only fire on delete.
        */
        if (trigger.isDelete){
            System.debug('Trigger context is: ' + trigger.operationType);
            for (Opportunity o : trigger.new){
                if(o.StageName == 'Closed Won' &&
                    o.Account.Industry == 'Banking'){
                    o.addError('Cannot delete closed opportunity for a banking account that is won');
                }
            }
        }

        if (trigger.isUpdate){
            for(Opportunity opp : trigger.new){
                if(opp.Amount < 5000){
                    opp.addError('Opportunity amount must be greater than 5000');
                }
            }
        }
    }
}