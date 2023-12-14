@isTest
global class ucl_LegalAccountsCalloutMock implements HttpCalloutMock
{
    global HTTPResponse respond(HTTPRequest req)
    {
        System.assertEquals('https://altimetrik-bootcamp.herokuapp.com/LegalAccounts', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(
          '['
            +'{' + 
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
             '}' +
          ']'
        );
        res.setStatusCode(200);
        return res;
    }
}