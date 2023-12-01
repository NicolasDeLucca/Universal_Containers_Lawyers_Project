public with sharing class ucl_ErrorLogController
{
    @AuraEnabled(cacheable=true)
    public static List<ErrorLog__c> getErrorLogs()
    {
        return [SELECT Id, Name, ErrorMessage__c FROM ErrorLog__c];
    }
}