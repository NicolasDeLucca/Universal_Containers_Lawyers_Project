public with sharing class ucl_ErrorLogService implements Schedulable, Database.AllowsCallouts 
{
    private static Integer deadlineDays = 30;

    public void execute(SchedulableContext SC) 
    {
        try
        {
            ucl_ErrorLogController.deleteErrorLogs(deadlineDays);
        }
        catch (Exception e)
        {
            ucl_ErrorHandler.handleError(e.getMessage());
        }
    }
}