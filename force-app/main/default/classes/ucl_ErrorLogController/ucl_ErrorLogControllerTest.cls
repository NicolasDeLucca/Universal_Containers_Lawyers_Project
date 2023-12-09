@isTest
private class ucl_ErrorLogControllerTest
{
    @isTest static void testGetErrorLogs()
    {
        //Arrange
        ErrorLog__c log = new ErrorLog__c(
            CreatedByUser__c = false, 
            ErrorMessage__c='Action restricted.'
        );
        insert log;

        //Act
        Test.startTest();
        List<ErrorLog__c> logs = ucl_ErrorLogController.getErrorLogs();
        Test.stopTest();

        //Assert
        System.assert.IsTrue(logs.size() == 1);
        System.assertEquals(logs[0].ErrorMessage__c, 'Action restricted.');
    }

    @isTest static void testErrorLogsShouldNotBeDeleted()
    {
        Integer completedDays = 2; 
        //Arrange
        ErrorLog__c log = new ErrorLog__c(
            CreatedByUser__c = false, 
            ErrorMessage__c='Action restricted.'
        );
        insert log;

        //Act
        Test.startTest();
        ucl_ErrorLogController.deleteErrorLogs(completedDays); 
        Test.stopTest();

        //Assert
        List<ErrorLog__c> logs = 
        [
            SELECT Id 
            FROM ErrorLog__c 
            WHERE Id = :log.Id
        
        ];
        System.assert.IsTrue(logs.size() == 1);
    }
}