@isTest
public with sharing class BatchCountContactMock implements BatchCountContactsInterface {
    public void batchMethod() {
        throw new TestClassException('I got some error');
    }
}