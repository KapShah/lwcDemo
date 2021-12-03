/*
Test Class: BatchCountContactsTest
*/
public without sharing class ContactTriggerHelper {

    public static void onBeforeInsert(List<Contact> newList){    
       updateIndustry(newList); 
    }
    
    public static void onBeforeUpdate(Map<Id, Contact> oldMap, Map<Id, Contact> newMap) {
        updateIndustry(newMap.values());
    }
    
    public static void onAfterInsert(Map<Id, Contact> newMap) {
    
    }
    
    public static void onAfterUpdate(Map<Id, Contact> oldMap, List<Contact> newList) {
    }
    
    private static void updateIndustry(List<Contact> newList) {
        Set<Id> accIds = new Set<Id>();
        Map<Id, String> mapAccountIndustryById = new Map<Id, String>();
        
        for(Contact con: newList) {
            accIds.add(con.AccountId);
        }        
        List<Account> accList = [SELECT Id, Industry FROM Account WHERE Id IN: accIds];
        
        if(accList.size() > 0) {
            for(Account acc: accList) {
                mapAccountIndustryById.put(acc.Id, acc.Industry);
            }
        }
        
        if(mapAccountIndustryById.size() > 0) {
            for(Contact con: newList) {
                con.Account_Industry__c = mapAccountIndustryById.get(con.AccountId);    
            }
        }
        
    
    }

}