public with sharing class ucl_AdminService
{
    private static Map<String, String> getUniqueClientIdsFromJson()
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

    public static void deleteClientsNotInJson()
    {
        Map<String, String> parsedClientIds = getUniqueClientIdsFromJson();

        List<Client__c> clientsToDelete =
        [
            SELECT Id
            FROM Client__c
            WHERE Legal_Advisor__c IN :parsedClientIds.keySet()
                AND Client_Number__c NOT IN :parsedClientIds.get(Legal_Advisor__c.Account_Number__c)
        ];

        if (!clientsToDelete.isEmpty())
        {
            delete clientsToDelete;
        }
    }

    public ucl_AdminService()
    {
    }
}