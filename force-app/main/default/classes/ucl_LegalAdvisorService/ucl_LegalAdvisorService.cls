public with sharing class ucl_LegalAdvisorService
{
    private static Boolean hasEnabledStatus(List<Legal_Advisor__c> existingLegalAdvisors, String accountNumber)
    {
        for (Legal_Advisor__c legalAdvisor : existingLegalAdvisors)
        {
            if (legalAdvisor.Account_Number__c == accountNumber && legalAdvisor.Account_Status__c == 'Enabled')
            	return true;
        }    

        return false;
    }

    private static void processClients(List<Legal_Advisor__c> legalAdvisors, Map<String, List<ucl_Client>> clientsMap)
    {
        List<Client__c> processedClients = new List<Client__c>();
        for (Legal_Advisor__c legalAdvisor : legalAdvisors) 
        {
            List<ucl_Client> clients = clientsMap.get(legalAdvisor.Account_Number__c);
            if (clients != null)
            {
                for (ucl_Client client : clients)
                {
                    Client__c clientRecord = new Client__c();
                    clientRecord.Name = client.FirstName + ' ' + client.LastName;
                    clientRecord.First_Name__c = client.FirstName;
                    clientRecord.Last_Name__c = client.LastName;
                    clientRecord.Email__c = client.Email;
                    clientRecord.Phone__c = client.Phone;
                    clientRecord.Address__c = client.Address;
                    clientRecord.Client_Number__c = client.ClientNumber;
                    clientRecord.Legal_Advisor__c = legalAdvisor.Id;
                    clientRecord.CreatedByUser__c = false;
                    processedClients.add(clientRecord); 
                }
            }
        } 		

        if (!processedClients.isEmpty())
        {
            upsert processedClients Client_Number__c; 
        }
    }

    public static void processLegalAdvisors(List<ucl_LegalAdvisor> legalAdvisors)
    {
        Map<String, List<ucl_Client>> clientsMap = new Map<String, List<ucl_Client>>();
        Map<String, Legal_Advisor__c> existingLegalAdvisorsMap = new Map<String, Legal_Advisor__c>();
        List<Legal_Advisor__c> legalAdvisorsToUpdate = new List<Legal_Advisor__c>();

        List<Legal_Advisor__c> existingLegalAdvisors =
        [
            SELECT Id, Account_Number__c, Account_Status__c 
            FROM Legal_Advisor__c
        ];

        for (Legal_Advisor__c legalAdvisor : existingLegalAdvisors)
        {
            existingLegalAdvisorsMap.put(legalAdvisor.Account_Number__c, legalAdvisor);
        }

        for (ucl_LegalAdvisor legalAdvisorModel : legalAdvisors)
        {
            Legal_Advisor__c legalAdvisor = existingLegalAdvisorsMap.get(legalAdvisorModel.AccountNumber);
              
			if (
             legalAdvisor == null || 
             legalAdvisorModel.AccountStatus == 'Enabled' || 
             hasEnabledStatus(existingLegalAdvisorsMap.values(), legalAdvisorModel.AccountNumber)
            )
            {
                if (legalAdvisor == null)
                {
                    legalAdvisor = new Legal_Advisor__c();
                    legalAdvisor.Account_Number__c = legalAdvisorModel.AccountNumber;
                }
                
                legalAdvisor.Account_Name__c = legalAdvisorModel.AccountName;
                legalAdvisor.Name = legalAdvisorModel.AccountName;
                legalAdvisor.Account_Status__c = legalAdvisorModel.AccountStatus;
                    
                String inputDate = legalAdvisorModel.AsOfDate;
                List<String> dateParts = inputDate.split('/');
                String formattedDate = dateParts[2] + '-' + dateParts[0] + '-' + dateParts[1];
                legalAdvisor.As_Of_Date__c = Date.valueOf(formattedDate);
            
                clientsMap.put(legalAdvisor.Account_Number__c, legalAdvisorModel.Clients);
                legalAdvisorsToUpdate.add(legalAdvisor);
            }           
        }            

        if (!clientsMap.isEmpty())
        {
            //dml operations
            upsert legalAdvisorsToUpdate Account_Number__c;
            processClients(legalAdvisorsToUpdate, clientsMap);
        }
    }
}