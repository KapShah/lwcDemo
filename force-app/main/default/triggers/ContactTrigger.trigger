trigger ContactTrigger on Contact (before insert, before update, after insert, after update ) {

    if (trigger.isBefore){
        if (trigger.isInsert){
          system.debug('### Enter ContactTriggerHelper.onBeforeInsert');
            ContactTriggerHelper.onBeforeInsert(trigger.new);
            system.debug('### Exit ContactTriggerHelper.onBeforeInsert');
        } 
        else if (trigger.isUpdate){
          system.debug('### Enter ContactTriggerHelper.onBeforeUpdate');
            ContactTriggerHelper.onBeforeUpdate(trigger.oldMap, trigger.newMap);
            system.debug('### Exit ContactTriggerHelper.onBeforeUpdate'); 
        }
    } 

    else if (trigger.isAfter){
        if (trigger.isInsert){
          system.debug('### Enter ContactTriggerHelper.onAfterInsert');
            ContactTriggerHelper.onAfterInsert(trigger.newMap);
            system.debug('### Exit ContactTriggerHelper.onAfterInsert');
        } 
        else if (trigger.isUpdate){
          system.debug('### Enter ContactTriggerHelper.onAfterUpdate');
            ContactTriggerHelper.onAfterUpdate(trigger.oldMap, trigger.new);
            system.debug('### Exit ContactTriggerHelper.onAfterUpdate');
        }
    }

}