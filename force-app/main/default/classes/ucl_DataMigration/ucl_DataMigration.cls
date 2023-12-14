public with sharing class ucl_DataMigration
{
    @AuraEnabled
    @future(callout=true)
    public static void migrateData()
    {
        String legalAdvisorsJson = ucl_HerokuIntegrationService.fetchLegalAccounts();
        if (legalAdvisorsJson != null)
        {
            List<ucl_LegalAdvisor> legalAdvisors = ucl_DataParser.parseLegalAdvisorsFromJson(legalAdvisorsJson);
            ucl_LegalAdvisorService.processLegalAdvisors(legalAdvisors);
            ucl_AdminService.deleteClientsNotInJson(legalAdvisors);
        }
    }
}