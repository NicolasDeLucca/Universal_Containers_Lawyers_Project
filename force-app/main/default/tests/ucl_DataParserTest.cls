@isTest
private class ucl_DataParserTest
{
	@isTest static void jsonParserReturnsLegalAdvisorsAsExpected()
    {
        String jsonInput =  
        '[{' + 
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
        '}]';
        
        List<ucl_LegalAdvisor> parsedLegalAdvisors = ucl_DataParser.parseLegalAdvisorsFromJson(jsonInput);
        
        System.Assert.IsTrue(!parsedLegalAdvisors.isEmpty());
        System.Assert.IsTrue(parsedLegalAdvisors.size() == 1);
        
        ucl_LegalAdvisor retrievedAdvisor = parsedLegalAdvisors[0];
        
        System.AssertEquals(retrievedAdvisor.AccountNumber, 'a209ebbb-39c6-4852-8732-82237c0674fb');
        System.AssertEquals(retrievedAdvisor.AccountName, 'Fadeo');
        System.AssertEquals(retrievedAdvisor.AccountStatus, 'Enabled');
        System.AssertEquals(retrievedAdvisor.AsOfDate, '2/20/2019');
        
        List<ucl_Client> parsedAdvisorClients = retrievedAdvisor.Clients;
        
        System.Assert.IsTrue(!parsedAdvisorClients.isEmpty());
        System.Assert.IsTrue(parsedAdvisorClients.size() == 1);
        
        ucl_Client parsedClient = parsedAdvisorClients[0];
        
        System.AssertEquals(parsedClient.FirstName, 'Fran');
        System.AssertEquals(parsedClient.LastName, 'Ruddick');
        System.AssertEquals(parsedClient.Email, 'fruddick0@issuu.com');
        System.AssertEquals(parsedClient.Phone, '390-285-2477');
        System.AssertEquals(parsedClient.Address, '434 Maple Drive');
        System.AssertEquals(parsedClient.ClientNumber, '12afa152-8115-492b-bb49-87399ab49af8');                    
    }
}