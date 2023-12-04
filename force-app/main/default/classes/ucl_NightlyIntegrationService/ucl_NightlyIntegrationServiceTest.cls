@isTest
private class ucl_NightlyIntegrationServiceTest
{
    @isTest static void testIntegrationExecution()
    {
        Test.startTest();
        ucl_NightlyIntegrationService integrationService = new ucl_NightlyIntegrationService();
        integrationService.execute(null); 
        Test.stopTest();
    }
}