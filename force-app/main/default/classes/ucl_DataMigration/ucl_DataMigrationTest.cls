@isTest
private class ucl_DataMigrationTest
{
    @isTest static void testMigrationOfData()
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ucl_LegalAccountsCalloutMock());
        ucl_DataMigration.migrateData();
        Test.stopTest();
    }
}