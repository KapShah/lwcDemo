@isTest
public with sharing class AccountControllerTest {

    @TestSetup
    static void setup(){
        List<Account> accList = new List<Account>();
        for (Integer i=0; i <2; i++) {
            Account a = new Account();
            a.Name = 'Test Account' + i;
            a.Industry = 'Finance';
            accList.add(a);
        }
        insert accList;
    }

    @isTest
    static void testSearch(){
            
        List<Account> accList = AccountController.getAccounts();
        System.assertEquals(2, accList.size());
        
        list<Account> accDetail = AccountController.getAccountDetails(accList[0].id);
        System.assertEquals(accDetail[0].id, accList[0].id);
    }
    
}