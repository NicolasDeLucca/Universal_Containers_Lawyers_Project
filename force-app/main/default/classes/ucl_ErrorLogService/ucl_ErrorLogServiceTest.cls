@isTest
private class ucl_ErrorLogServiceTest
{
    @isTest static void testOldErrorLogsExecution()
    {
        Test.startTest();
        ucl_ErrorLogService deletionService = new ucl_ErrorLogService();
        deletionService.execute(null); 
        Test.stopTest();
    }
}