public class AccountController {
 @AuraEnabled(cacheable=true)
    public static List<Lead> getLimitedAccounts(){
        List<Lead> accounts = [SELECT
               Id, Name, Phone
               FROM Lead ORDER BY CreatedDate LIMIT 2000];
        return accounts;
    }
}