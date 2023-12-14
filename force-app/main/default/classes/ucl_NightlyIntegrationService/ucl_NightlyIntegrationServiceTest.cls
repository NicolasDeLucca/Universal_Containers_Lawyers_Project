@isTest
private class ucl_NightlyIntegrationServiceTest
{
    @isTest static void testIntegrationExecution()
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ucl_LegalAccountsCalloutMock());
        ucl_NightlyIntegrationService integrationService = new ucl_NightlyIntegrationService();
        integrationService.execute(null); 
        Test.stopTest();
    }
}