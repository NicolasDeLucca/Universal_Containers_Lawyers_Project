public with sharing class ucl_ErrorLogController
{
    @AuraEnabled(cacheable=true)
    public static List<ErrorLog__c> getErrorLogs()
    {
        return [SELECT Id, Name, ErrorMessage__c FROM ErrorLog__c];
    }

    @future(callout=true)
    public static void deleteErrorLogs(Integer deadlineDays)
    {
        Date limitCreatedDate = Date.today().addDays(-deadlineDays);

        List<ErrorLog__c> errorLogs = 
        [
            SELECT Id 
            FROM ErrorLog__c 
            WHERE CreatedDate < :limitCreatedDate
        ];

        delete errorLogs;
    }
}