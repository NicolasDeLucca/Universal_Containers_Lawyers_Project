trigger ucl_ErrorLogDmlOperationTrigger on ErrorLog__c (before insert, before update, before delete) 
{
    for (ErrorLog__c error : Trigger.New)
    {
     	if (
          Trigger.isInsert && 
          error.CreatedByUser__c || 
          Trigger.isUpdate || 
          Trigger.isDelete)
        {
            string message = 'errors are for read only';
            error.addError(message);
            ucl_ErrorHandler.HandleError(message);
        }
    }
}