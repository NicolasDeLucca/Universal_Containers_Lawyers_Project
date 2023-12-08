@isTest
public class ucl_AdminServiceTest
{
    @isTest static void testDeleteClientsNotInJson()
    {
        //Arrange

        Legal_Advisor__c legalAdvisor = new Legal_Advisor__c
        (
            Account_Number__c = 'a209ebbb-39c6-4852-8732-82237c0674fb',
            Account_Name__c = 'Fadeo',
            Account_Status__c = 'Enabled'
        );
        
        insert legalAdvisor;
        
        Client__c client = new Client__c
        (
            Legal_Advisor__c = legalAdvisor.Id,
            First_Name__c = 'Fran',
            Last_Name__c = 'Ruddick',
            Email__c = 'fruddick0@issuu.com',
            Phone__c = '390-285-2477',
            Address__c = '434 Maple Drive',
            Client_Number__c = 'different-client-number', // This client number is different from the one in the JSON data
            CreatedByUser__c = false
        );
        
        insert client;
        
        String jsonData = 
            '[' +
             '{' + 
                '"AccountNumber": "a209ebbb-39c6-4852-8732-82237c0674fb",' + 
                '"AccountName": "Fadeo",' +
                '"AccountStatus": "Enabled",' +
                '"AsOfDate": "2/20/2019",' + 
                '"Clients": [' + 
                    '{'+               
                        '"FirstName": "Fran",'+
                        '"LastName": "Ruddick",'+
                        '"Email": "fruddick0@issuu.com",'+
                        '"Phone": "390-285-2477",'+
                        '"Address": "434 Maple Drive",'+
                        '"ClientNumber": "12afa152-8115-492b-bb49-87399ab49af8"'+
                    '}'+
                ']'+
             '}'+
            ']';
        
        //Act

        Test.startTest();
        ucl_AdminService.deleteClientsNotInJson(jsonData);
        Test.stopTest();
        
        Integer clientCount = 
        [
            SELECT COUNT() 
            FROM Client__c 
            WHERE CreatedByUser__c = false AND Legal_Advisor__c = :legalAdvisor.Id
        ];

        //Assert
        
        System.assertEquals(0, clientCount, 'The number of Client__c records should be 0');
    }
}