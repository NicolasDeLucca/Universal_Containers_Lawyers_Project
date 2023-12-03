@isTest
private class ucl_ErrorLogControllerTest
{
	@isTest static void retrieveErrorLogsAsExpected()
    {
        List<ErrorLog__c> expectedErrorLogs = 
        [
           SELECT Id, Name, ErrorMessage__c 
           FROM ErrorLog__c
        ];
            
        List<ErrorLog__c> ActualErrorLogs = ucl_ErrorLogController.getErrorLogs();
        System.AssertEquals(expectedErrorLogs, ActualErrorLogs);
    }
}