public with sharing class ucl_LegalAdvisorService
{
    private static Boolean shouldBeProccessed(String accountNumber, String accountStatus)
    {
        if (accountStatus == 'Enabled')
        {
            return true;
        }

        List<Legal_Advisor__c> existingLegalAdvisors = 
        [
            SELECT Id, Account_Status__c
            FROM Legal_Advisor__c
            WHERE Account_Number__c = :accountNumber
        ];

        if (!existingLegalAdvisors.isEmpty())
        {
            Legal_Advisor__c existingLegalAdvisor = existingLegalAdvisors[0];
            return existingLegalAdvisor.Account_Status__c == 'Enabled';
        }

        return true;
    }

    private static void processClients(Legal_Advisor__c legalAdvisor, List<ucl_Client> clients)
    {
        List<Client__c> processedClients = new List<Client__c>();
        if (clients != null && !clients.isEmpty())
        {
            for (ucl_Client client : clients)
            {
                Client__c clientRecord = new Client__c();
                clientRecord.Name = client.FirstName + ' ' +client.LastName;
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
        
        if (!processedClients.isEmpty())
        {
            upsert processedClients Client_Number__c;
        }
    }

    public static void processLegalAdvisors(List<ucl_LegalAdvisor> legalAdvisors)
    {
        List<Legal_Advisor__c> legalAdvisorRecordsToUpdate = new List<Legal_Advisor__c>();

        for (ucl_LegalAdvisor legalAdvisorModel : legalAdvisors)
        {
            Legal_Advisor__c legalAdvisor = new Legal_Advisor__c();
            legalAdvisor.Account_Number__c = legalAdvisorModel.AccountNumber;
            legalAdvisor.Account_Name__c = legalAdvisorModel.AccountName;
            legalAdvisor.Name = legalAdvisorModel.AccountName;
            legalAdvisor.Account_Status__c = legalAdvisorModel.AccountStatus;
            String inputDate = legalAdvisorModel.AsOfDate;

            List<String> dateParts = inputDate.split('/');
            String formattedDate = dateParts[2] + '-' + dateParts[0] + '-' + dateParts[1];
            legalAdvisor.As_Of_Date__c = Date.valueOf(formattedDate);

            if (shouldBeProccessed(legalAdvisor.Account_Number__c, legalAdvisor.Account_Status__c))
            {
                legalAdvisorRecordsToUpdate.add(legalAdvisor);

                if (!legalAdvisorRecordsToUpdate.isEmpty())
                {
                    upsert legalAdvisorRecordsToUpdate Account_Number__c;
                    processClients(legalAdvisor, legalAdvisorModel.Clients);
                }
            }
        }
    }
}