public with sharing class ucl_NightlyIntegrationService implements Schedulable
{
    public void execute(SchedulableContext SC)
    {
        try
        {
            ucl_DataMigration.migrateData();
        }
        catch (Exception e)
        {
            ucl_ErrorHandler.HandleError(e.getMessage());
        }
    }

    public ucl_NightlyIntegrationService()
    {
    }
}