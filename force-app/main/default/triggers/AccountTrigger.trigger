trigger AccountTrigger on Account (before insert, after insert) {
    /*** Question 1
    * Account Trigger
    * When an account is inserted change the account type to 'Prospect' if there is no value in the type field.
    * Trigger should only fire on insert. */
    if (trigger.isBefore && trigger.isInsert){
        for(Account acc : trigger.new ){
            if(acc.Type == null){
                acc.Type = 'Prospect';
            }
            /*
            * Question 2
            * Account Trigger
            * When an account is inserted copy the shipping address to the billing address.
            * BONUS: Check if the shipping fields are empty before copying.
            * Trigger should only fire on insert.
            */
            if (acc.ShippingStreet != null){
                acc.BillingStreet = acc.ShippingStreet;
            }
            if (acc.ShippingCity != null){
                acc.BillingCity = acc.ShippingCity;
            }
            if (acc.ShippingState != null){
                acc.BillingState = acc.ShippingState;                
            }
            if (acc.ShippingPostalCode != null){
                acc.BillingPostalCode = acc.ShippingPostalCode;  
            }
            if (acc.ShippingCountry!= null){
                acc.BillingCountry = acc.ShippingCountry;  
            }            

            /*
            * Question 3
            * Account Trigger
            * When an account is inserted set the rating to 'Hot' if the Phone, Website, and Fax ALL have a value.
            * Trigger should only fire on insert.
            */
            If( acc.Phone   != null &&
                acc.Website != null &&
                acc.Fax     != null) {
                acc.Rating  = 'Hot';
            }
        }
    }
    if (trigger.isAfter){
        if(Trigger.isInsert){
            /*
            * Question 4
            * Account Trigger
            * When an account is inserted create a contact related to the account with the following default values:
            * LastName = 'DefaultContact'
            * Email = 'default@email.com'
            * Trigger should only fire on insert.
            */
            //list of contacts; generate for loop trigger.new; insert account, associate account ID
            List<Contact> conList = new List<Contact>();
            for (Account newAcc : trigger.new) {

                Contact con     = new Contact(
                    LastName    = 'DefaultContact',
                    Email       = 'default@email.com',
                    AccountId   = newAcc.Id);
                //add record(s) to list
                conlist.add(con);
            }
            System.debug('conList records: ' + conList);
            //Database.insert(conList, AccessLevel.USER_MODE);
            insert conList;
        }
    }// not sure why the error is being produced using Database.insert. I must keep moving.
}