public with sharing class ucl_DataParser
{
    private static List<ucl_Client> parseClientsFromMapList(List<Object> clientList)
    {
        List<ucl_Client> clients = new List<ucl_Client>();

        for (Object client : clientList)
        {
            Map<String, Object> clientMap = (Map<String, Object>) client;

            ucl_Client clientModel = new ucl_Client();
            clientModel.FirstName = (String) clientMap.get('FirstName');
            clientModel.LastName = (String) clientMap.get('LastName');
            clientModel.Email = (String) clientMap.get('Email');
            clientModel.Phone = (String) clientMap.get('Phone');
            clientModel.Address = (String) clientMap.get('Address');
            clientModel.ClientNumber = (String) clientMap.get('ClientNumber');

            clients.add(clientModel);
        }

        return clients;
    }
    
    public static List<ucl_LegalAdvisor> parseLegalAdvisorsFromJson(String jsonData)
    {
        List<ucl_LegalAdvisor> parsedLegalAdvisors = new List<ucl_LegalAdvisor>();
        List<Object> jsonList = (List<Object>) JSON.deserializeUntyped(jsonData);

        if (jsonList != null)
        {
            for (Object LegalAdvisor : jsonList)
            {
                Map<String, Object> LegalAdvisorMap = (Map<String, Object>) LegalAdvisor;

                ucl_LegalAdvisor legalAdvisorModel = new ucl_LegalAdvisor();
                legalAdvisorModel.AccountNumber = (String) LegalAdvisorMap.get('AccountNumber');
                legalAdvisorModel.AccountName = (String) LegalAdvisorMap.get('AccountName');
                legalAdvisorModel.AccountStatus = (String) LegalAdvisorMap.get('AccountStatus');
                legalAdvisorModel.AsOfDate = (String) LegalAdvisorMap.get('AsOfDate');
                
                List<Object> clients = (List<Object>) LegalAdvisorMap.get('Clients');
                if (clients != null)
                {
                    legalAdvisorModel.Clients = parseClientsFromMapList(clients);
                    parsedLegalAdvisors.add(legalAdvisorModel);
                }
            }
        }
 
        return parsedLegalAdvisors;
    }
}