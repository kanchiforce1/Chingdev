global class batchClassCallout implements 
    Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    public List<string> strList = new List<string>();
    public List<PPW_StaticUtils> obj = new List<PPW_StaticUtils>();
    global Database.QueryLocator start(Database.BatchableContext bc) {
    
      Http h = new Http();
    
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.exchangeratesapi.io/latest?base=AUD');
        req.setMethod('GET');
        String resCurrecys;
        HttpResponse res = h.send(req);
        strList.add('test');
        obj.add(new PPW_StaticUtils());
        system.debug(res.getBody());
        return Database.getQueryLocator(
            'SELECT ID, BillingStreet, BillingCity, BillingState, ' +
            'BillingPostalCode, (SELECT ID, MailingStreet, MailingCity, ' +
            'MailingState, MailingPostalCode FROM Contacts) FROM Account ' + 
            'LIMIT 2'
        );
    }
    global void execute(Database.BatchableContext bc, List<Account> scope) {
        // process each batch of records
        List<Contact> contacts = new List<Contact>();
        system.debug(strList);
        system.debug(obj);
        for (Account account : scope) {
            for (Contact contact : account.contacts) {
                contact.MailingStreet = account.BillingStreet;
                contact.MailingCity = account.BillingCity;
                contact.MailingState = account.BillingState;
                contact.MailingPostalCode = account.BillingPostalCode;
                // add contact to list to be updated
                contacts.add(contact);
                // increment the instance member counter
                recordsProcessed = recordsProcessed + 1;
            }
        }
        update contacts;
    }    
    global void finish(Database.BatchableContext bc){
       
    }    
}