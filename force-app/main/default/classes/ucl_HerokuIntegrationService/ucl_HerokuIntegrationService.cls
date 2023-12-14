public with sharing class ucl_HerokuIntegrationService implements Database.AllowsCallouts
{
    public static Integer SUCCESS = 200;
    public static String LEGAL_ACCOUNTS_ENDPOINT = 
        'https://altimetrik-bootcamp.herokuapp.com/LegalAccounts';
     
    public static String fetchLegalAccounts()
    {
        String body = null;
    
        HttpRequest req = new HttpRequest();
        req.setEndpoint(LEGAL_ACCOUNTS_ENDPOINT);
        req.setMethod('GET');
     
        Http http = new Http();
        HttpResponse res = http.send(req);
    
        if (res.getStatusCode() == SUCCESS)
        {
            body = res.getBody();
        }
        
        return body;
    }
}