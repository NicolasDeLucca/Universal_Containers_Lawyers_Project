@isTest
private class ucl_HerokuIntegrationServiceTest
{
	@isTest static void fetchLegalAccountsRetrieveInformation()
    {
        Test.setMock(HttpCalloutMock.class, new ucl_LegalAccountsCalloutMock());
    	String actualResponseBody = ucl_HerokuIntegrationService.fetchLegalAccounts(); 
        System.assert.IsNotNull(actualResponseBody);
    }
    
    @isTest static void fetchLegalAccountsWorks()
    {
        Test.setMock(HttpCalloutMock.class, new ucl_LegalAccountsCalloutMock());
        String expectedResponseBody =  
        '{"legalAccounts":' +
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
            ']'+
           '}';
        
        String actualResponseBody = ucl_HerokuIntegrationService.fetchLegalAccounts();

        System.assertEquals(expectedResponseBody, actualResponseBody);
    }
}