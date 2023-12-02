public with sharing class ucl_ErrorHandler
{
    private static void logError(String errorMessage)
    {
        try
        {
            ErrorLog__c errorLog = new ErrorLog__c();
            errorLog.ErrorMessage__c = errorMessage;
            insert errorLog;
        }
        catch (Exception e)
        {
            System.debug('Error logging failed: ' + e.getMessage());
        }
    }

    private static void sendErrorEmail(String errorMessage)
    {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String adminAddress = System.Label.Admin_Email_Label;
        String[] addresses = new String[]{adminAddress}; 
        email.setToAddresses(addresses);
        email.setSubject('Error Notification');
        email.setPlainTextBody('An error occurred: ' + errorMessage);

        try
        {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
        }
        catch (Exception e)
        {
            System.debug('Email sending failed: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static void handleError(String errorMessage)
    {
        logError(errorMessage);
        sendErrorEmail(errorMessage);
    }
}