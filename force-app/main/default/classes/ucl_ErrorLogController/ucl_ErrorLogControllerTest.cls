@isTest
private class ucl_ErrorLogControllerTest
{
    @isTest static void testGetErrorLogs()
    {
        //Arrange
        ErrorLog__c log = new ErrorLog__c(CreatedByUser__c = false, ErrorMessage__c='Test Error');
        insert log;

        //Act
        Test.startTest();
        List<ErrorLog__c> logs = ucl_ErrorLogController.getErrorLogs();
        Test.stopTest();

        //Assert
        ErrorLog__c log = logs[0];
        System.assertEquals(1, logs.size());
        System.assertEquals('Test Error', log.ErrorMessage__c);
    }

    @isTest static void testErrorLogsShouldNotBeDeleted()
    { 
        //Arrange
        ErrorLog__c log = new ErrorLog__c(CreatedByUser__c = false, ErrorMessage__c='Test Error');
        insert log;
        Integer completedDays = 2;

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

    @isTest static void testErrorLogsShouldBeDeleted()
    {
        //Arrange
        ErrorLog__c log = new ErrorLog__c(CreatedByUser__c = false, ErrorMessage__c='Test Error');
        insert log;
        Integer completedDays = 31;

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
        System.assert.IsTrue(logs.size() == 0);
    }
}