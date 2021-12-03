/*
TestClass: BatchCountContactsTest
*/

global class BatchCountContacts implements Database.Batchable<sObject>, Database.Stateful, Schedulable {
    
    global List<Log__c> logs;
    public BatchCountContactsInterface countInterface;
    global BatchCountContacts () {
        logs = new List<Log__c>();
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {    
        String query = 'SELECT Id, Name, Number_of_Contacts__c, (SELECT id FROM Contacts) FROM Account';
        return Database.getQueryLocator(query);
    }
                
    global void execute(Database.BatchableContext BC, List<Account> scope) {
        
        try {
            if(countInterface != null) { 
                countInterface.batchMethod();
            }
            for(Account a : scope) {
                a.number_of_contacts__c = a.Contacts.size();
            }
            update scope;
        } catch (Exception e) {
            logs.add(new Log__c(
                Name = 'BatchCountContacts',
                Stacktrace__c = e.getStackTraceString()
            ));
        }   
    }           
    
    global void finish(Database.BatchableContext BC) {
        insert logs;
    }
    
     public void execute(SchedulableContext sc) {
        Database.executeBatch(new BatchCountContacts (), 200);
    }        
}