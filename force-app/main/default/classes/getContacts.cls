public class getContacts {

@AuraEnabled
public static List<Contact> getAccContacts(String recId) {

    return [SELECT id,Name FROM Contact WHERE accountid=:recId];

}

}