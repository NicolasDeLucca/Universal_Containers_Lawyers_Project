public with sharing class ucl_AdminService
{
    private static Map<String, String> getUniqueClientIdsFromJson(String jsonData)
    {
        Map<String, String> uniqueClientIds = new Map<String, String>();
        
        List<ucl_LegalAdvisor> legalAdvisors = ucl_DataParser.parseLegalAdvisorsFromJson(jsonData);
        for (ucl_LegalAdvisor legalAdvisor : legalAdvisors)
        {
            List<ucl_Client> clients = legalAdvisor.Clients;
            if (clients != null && !clients.isEmpty())
            {
                for (ucl_Client client : clients)
                {
                    uniqueClientIds.put(legalAdvisor.AccountNumber, client.ClientNumber);
                }
            }
        }

        return uniqueClientIds;
    }

    public static void deleteClientsNotInJson(String jsonData)
    {
        Map<String, String> parsedClientIds = getUniqueClientIdsFromJson(jsonData);
    
        List<Legal_Advisor__c> legalAdvisors = 
        [
            SELECT Id, Account_Number__c 
            FROM Legal_Advisor__c 
            WHERE Account_Number__c IN :parsedClientIds.keySet()
        ];
    
        Map<Id, Legal_Advisor__c> legalAdvisorMap = new Map<Id, Legal_Advisor__c>(legalAdvisors);
    
        List<Client__c> allClients = 
        [
            SELECT Id, Legal_Advisor__c, Client_Number__c
            FROM Client__c 
            WHERE CreatedByUser__c = false
            AND Legal_Advisor__c IN :legalAdvisorMap.keySet()];
    
        List<Client__c> clientsToDelete = new List<Client__c>();
    
        for (Client__c client : allClients)
        {
            Legal_Advisor__c legalAdvisor = legalAdvisorMap.get(client.Legal_Advisor__c);
            if (client.Client_Number__c != parsedClientIds.get(String.valueOf(legalAdvisor.Account_Number__c)))
            {
                clientsToDelete.add(client);
            }
        }
    
        if (!clientsToDelete.isEmpty())
        {
            delete clientsToDelete;
        }
    }
}