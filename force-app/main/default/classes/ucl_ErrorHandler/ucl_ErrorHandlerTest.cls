@isTest
private class ucl_ErrorHandlerTest
{
	@isTest static void ErrorsAreLoggedCorrectly()
    {
        Integer errorsAmountbefore = [ SELECT COUNT() FROM ErrorLog__c ];
        
        String expectedErrorMessage = 'nothing works, its a mess';
    	ucl_ErrorHandler.HandleError(expectedErrorMessage);
        
        List<ErrorLog__c> errorsLogged =
        [
            SELECT ErrorMessage__c
            FROM ErrorLog__c
        ];
        
        System.AssertEquals(errorsAmountbefore + 1, errorsLogged.size());
        System.AssertEquals(expectedErrorMessage, errorsLogged[errorsLogged.size()-1].ErrorMessage__c);
    }
    
    @isTest static void ErrorMessagesAreSentToAdmin()
    {
        String errorMessage = 'HELP!!';
        String ExpectedEmailSubject = 'Error Notification';
        String ExpectedEmailBody = 'An error occurred: ' + errorMessage;
        String adminAddress = System.Label.Admin_Email_Label;
            
        Integer amountOfAdminEmails = [SELECT Count() FROM EmailMessage WHERE ToAddress = :adminAddress];
        
        Test.startTest();
        ucl_ErrorHandler.HandleError(errorMessage);
        Test.stopTest();
        
        List<EmailMessage> sentEmails = 
        [
            SELECT Subject, TextBody 
            FROM EmailMessage
            WHERE ToAddress = :adminAddress
        ];

        EmailMessage lastEmail = sentEmails[sentEmails.size()-1];
            
        System.AssertEquals(amountOfAdminEmails + 1, sentEmails.size());
        System.AssertEquals(lastEmail.Subject, ExpectedEmailSubject);
        System.AssertEquals(lastEmail.TextBody, ExpectedEmailBody);
    }    
}