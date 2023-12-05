@isTest
public class ucl_LegalAdvisorServiceTest
{
    @isTest static void testLegalAdvisorsProcess()
    {
        // Arrange

        Legal_Advisor__c testLegalAdvisor = new Legal_Advisor__c
        (
            Account_Number__c = 'TestAccountNumber',
            Account_Name__c = 'TestAccountName',
            Name = 'TestAccountName',
            Account_Status__c = 'Enabled',
            As_Of_Date__c = Date.today()
        );
        
        insert testLegalAdvisor;

        ucl_Client testClient = new ucl_Client();
        testClient.FirstName = 'TestFirstName';
        testClient.LastName = 'TestLastName';
        testClient.Email = 'test@example.com';
        testClient.Phone = '1234567890';
        testClient.Address = 'Test Address';
        testClient.ClientNumber = 'TestClientNumber';

        ucl_LegalAdvisor testLegalAdvisorModel = new ucl_LegalAdvisor();
        testLegalAdvisorModel.AccountNumber = 'TestAccountNumber';
        testLegalAdvisorModel.AccountName = 'TestAccountName';
        testLegalAdvisorModel.AccountStatus = 'Enabled';
        testLegalAdvisorModel.AsOfDate = String.valueOf(Date.today().month()) + '/' + String.valueOf(Date.today().day()) + '/' + String.valueOf(Date.today().year());
        testLegalAdvisorModel.Clients = new List<ucl_Client>{testClient};

        // Act    
        
        Test.startTest();
        ucl_LegalAdvisorService.processLegalAdvisors(new List<ucl_LegalAdvisor>{testLegalAdvisorModel});
        Test.stopTest();

        // Assert
        
        Legal_Advisor__c actualLegalAdvisor = [SELECT Id, Account_Number__c, Account_Name__c, Account_Status__c, As_Of_Date__c FROM Legal_Advisor__c WHERE Id = :testLegalAdvisor.Id];
        System.assertEquals(testLegalAdvisorModel.AccountNumber, actualLegalAdvisor.Account_Number__c);
        System.assertEquals(testLegalAdvisorModel.AccountName, actualLegalAdvisor.Account_Name__c);
        System.assertEquals(testLegalAdvisorModel.AccountStatus, actualLegalAdvisor.Account_Status__c);
        System.assertEquals(testLegalAdvisorModel.AsOfDate, String.valueOf(actualLegalAdvisor.As_Of_Date__c.month()) + '/' + String.valueOf(actualLegalAdvisor.As_Of_Date__c.day()) + '/' + String.valueOf(actualLegalAdvisor.As_Of_Date__c.year()));

        List<Client__c> actualClients = [SELECT Id, First_Name__c, Last_Name__c, Email__c, Phone__c, Address__c, Client_Number__c, Legal_Advisor__c FROM Client__c WHERE Legal_Advisor__c = :testLegalAdvisor.Id];
        System.assertEquals(1, actualClients.size());
        System.assertEquals(testClient.FirstName, actualClients[0].First_Name__c);
        System.assertEquals(testClient.LastName, actualClients[0].Last_Name__c);
        System.assertEquals(testClient.Email, actualClients[0].Email__c);
        System.assertEquals(testClient.Phone, actualClients[0].Phone__c);
        System.assertEquals(testClient.Address, actualClients[0].Address__c);
        System.assertEquals(testClient.ClientNumber, actualClients[0].Client_Number__c);
    }


@isTest static void testProcessLegalAdvisorsWithExistingEnabledLegalAdvisor() {
    // Prepare test data
    Legal_Advisor__c existingLegalAdvisor = new Legal_Advisor__c(
        Account_Number__c = 'TestAccountNumber',
        Account_Name__c = 'TestAccountName',
        Name = 'TestAccountName',
        Account_Status__c = 'Enabled',
        As_Of_Date__c = Date.today()
    );
    insert existingLegalAdvisor;

    ucl_Client testClient = new ucl_Client();
    testClient.FirstName = 'TestFirstName';
    testClient.LastName = 'TestLastName';
    testClient.Email = 'test@example.com';
    testClient.Phone = '1234567890';
    testClient.Address = 'Test Address';
    testClient.ClientNumber = 'TestClientNumber';

    ucl_LegalAdvisor testLegalAdvisorModel = new ucl_LegalAdvisor();
    testLegalAdvisorModel.AccountNumber = 'TestAccountNumber';
    testLegalAdvisorModel.AccountName = 'TestAccountName';
    testLegalAdvisorModel.AccountStatus = 'Disabled';
    testLegalAdvisorModel.AsOfDate = String.valueOf(Date.today().month()) + '/' + String.valueOf(Date.today().day()) + '/' + String.valueOf(Date.today().year());
    testLegalAdvisorModel.Clients = new List<ucl_Client>{testClient};

    Test.startTest();
    // Call the method to test
    ucl_LegalAdvisorService.processLegalAdvisors(new List<ucl_LegalAdvisor>{testLegalAdvisorModel});
    Test.stopTest();

    List<Client__c> actualClients = [SELECT Id, First_Name__c, Last_Name__c, Email__c, Phone__c, Address__c, Client_Number__c, Legal_Advisor__c FROM Client__c WHERE Legal_Advisor__c = :existingLegalAdvisor.Id];
    System.assertEquals(1, actualClients.size());
    System.assertEquals(testClient.FirstName, actualClients[0].First_Name__c);
    System.assertEquals(testClient.LastName, actualClients[0].Last_Name__c);
}}