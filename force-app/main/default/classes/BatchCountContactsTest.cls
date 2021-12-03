@isTest
private class BatchCountContactsTest {
    

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
    
        List<Contact> conList = new List<Contact>();
        for (Integer i=0; i < 2; i++) {
            Contact c = new Contact();
            c.Email = 'testContac@testEmail.com.invalid' + i;
            c.accountId = accList[0].id;
            c.FirstName = 'TestContact';
            c.LastName  = 'Contact' + i;
            conList.add(c);
        }
        insert conList;
    }

    @isTest
    static void testCountContacts() {
        Test.startTest();
            BatchCountContacts obj = new BatchCountContacts();
            DataBase.executeBatch(obj);  
        Test.stopTest();
        List<Account> accList = [SELECT Id, Name, number_of_contacts__c FROM Account ORDER BY Name];
        System.AssertEquals(2, accList[0].number_of_contacts__c);
        System.AssertEquals(0, accList[1].number_of_contacts__c);
    }

    @isTest
    static void testException() {
        Test.startTest();
            BatchCountContacts obj = new BatchCountContacts ();
            obj.countInterface = new BatchCountContactMock();
            DataBase.executeBatch(obj);
        Test.stopTest();
        list<Log__c> logs  = [SELECT Id FROM Log__c];
        System.AssertEquals(1, logs.size());
    }
    
    @isTest
    static void testContactUpdate() {
        
        Contact con = [SELECT Id, AccountId FROM Contact LIMIT 1];
        Test.startTest();
        	update con;
       	Test.stopTest();
    
        con = [SELECT Id, AccountId, Account_Industry__c FROM Contact WHERE Id =: con.Id];
        Account acc = [SELECT Id, Industry FROM Account WHERE Id =: con.AccountId];
        
        System.assertEquals(acc.Industry, con.Account_Industry__c);

        
    }

}