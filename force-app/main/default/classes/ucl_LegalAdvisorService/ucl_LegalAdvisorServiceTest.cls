@isTest
public class ucl_LegalAdvisorServiceTest
{
    @isTest static void testLegalAdvisorsProcess()
    {
        // Arrange    
        Date today = Date.today();

        ucl_Client testClientModel = new ucl_Client();
        testClientModel.FirstName = 'TestFirstName';
        testClientModel.LastName = 'TestLastName';
        testClientModel.Email = 'test@example.com';
        testClientModel.Phone = '1234567890';
        testClientModel.Address = 'Test Address';
        testClientModel.ClientNumber = 'TestClientNumber';

        ucl_LegalAdvisor testLegalAdvisorModel = new ucl_LegalAdvisor();
        testLegalAdvisorModel.AccountNumber = 'TestAccountNumber';
        testLegalAdvisorModel.AccountName = 'TestAccountName';
        testLegalAdvisorModel.AccountStatus = 'Enabled';
        testLegalAdvisorModel.AsOfDate = String.valueOf(today.month()) + '/' + 
            String.valueOf(today.day()) + '/' + String.valueOf(today.year());
        testLegalAdvisorModel.Clients = new List<ucl_Client>{testClientModel};

        Legal_Advisor__c testLegalAdvisor = new Legal_Advisor__c
        (
            Account_Number__c = 'TestAccountNumber',
            Account_Name__c = 'TestAccountName',
            Name = 'TestAccountName',
            Account_Status__c = 'Enabled',
            As_Of_Date__c = today
        );
        insert testLegalAdvisor;    
            
        // Act           
        Test.startTest();
        ucl_LegalAdvisorService.processLegalAdvisors(new List<ucl_LegalAdvisor>{testLegalAdvisorModel});
        Test.stopTest();
        
        // Assert
        Legal_Advisor__c actualLegalAdvisor = 
        [
        	SELECT Id, Account_Number__c, Account_Name__c, Account_Status__c, As_Of_Date__c 
            FROM Legal_Advisor__c 
            WHERE Account_Number__c = :testLegalAdvisor.Account_Number__c
        ];

        List<Client__c> actualClients =
        [
            SELECT Id, First_Name__c, Last_Name__c, Email__c, Phone__c, Address__c, Client_Number__c, Legal_Advisor__c 
            FROM Client__c 
            WHERE Legal_Advisor__c = :testLegalAdvisor.Id
        ];
        
        Client__c actualClient = actualClients[0];
        
		System.assertEquals(testLegalAdvisorModel.AccountNumber, actualLegalAdvisor.Account_Number__c);
        System.assertEquals(testLegalAdvisorModel.AccountName, actualLegalAdvisor.Account_Name__c);
        System.assertEquals(testLegalAdvisorModel.AccountStatus, actualLegalAdvisor.Account_Status__c);
        System.assertEquals(testLegalAdvisorModel.AsOfDate, String.valueOf(actualLegalAdvisor.As_Of_Date__c.month()) + '/' 
        	+ String.valueOf(actualLegalAdvisor.As_Of_Date__c.day()) + '/' + String.valueOf(actualLegalAdvisor.As_Of_Date__c.year()));
        
        System.assert.IsTrue(actualClients.size() == 1);
        System.assertEquals(testClientModel.FirstName, actualClient.First_Name__c);
        System.assertEquals(testClientModel.LastName, actualClient.Last_Name__c);
        System.assertEquals(testClientModel.Email, actualClient.Email__c);
        System.assertEquals(testClientModel.Phone, actualClient.Phone__c);
        System.assertEquals(testClientModel.Address, actualClient.Address__c);
        System.assertEquals(testClientModel.ClientNumber, actualClient.Client_Number__c);
    }
}