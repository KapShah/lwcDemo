public with sharing class AccountController {
    public AccountController() {

    }

    @AuraEnabled (Cacheable = True)
    public static List<Account> getAccounts() {
        RETURN [SELECT Id, Name FROM Account LIMIT 5];
    }

    @AuraEnabled (Cacheable = True)
    public static List<Account> getAccountDetails(String accountId) {

        RETURN [SELECT Id, Name, Industry, Type, Owner.Name, Owner.SmallPhotoUrl FROM Account WHERE Id =: accountId ];
    }

}