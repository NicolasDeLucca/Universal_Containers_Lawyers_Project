public with sharing class ucl_AdminService
{
    private static Map<String, List<String>> getUniqueClientIdsFromJson(List<ucl_LegalAdvisor> parsedLegalAdvisors)
    {
        Map<String, List<String>> uniqueClientIds = new Map<String, List<String>>();
        
        for (ucl_LegalAdvisor legalAdvisor : parsedLegalAdvisors)
        {
            List<ucl_Client> clients = legalAdvisor.Clients;
            if (clients != null && !clients.isEmpty())
            {
                List<String> clientNumbers = new List<String>();
                for (ucl_Client client : clients)
                {
                    clientNumbers.add(client.ClientNumber);
                }
                uniqueClientIds.put(legalAdvisor.AccountNumber, clientNumbers);
            }
        }

        return uniqueClientIds;
    }

    public static void deleteClientsNotInJson(List<ucl_LegalAdvisor> parsedLegalAdvisors)
    {
        Map<String, List<String>> parsedClientIds = getUniqueClientIdsFromJson(parsedLegalAdvisors);
    
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
            AND Legal_Advisor__c IN :legalAdvisorMap.keySet()
        ];
    
        List<Client__c> clientsToDelete = new List<Client__c>();
    
        for (Client__c client : allClients)
        {
            Legal_Advisor__c legalAdvisor = legalAdvisorMap.get(client.Legal_Advisor__c);
            if (!parsedClientIds.get(String.valueOf(legalAdvisor.Account_Number__c)).
                contains(client.Client_Number__c))
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