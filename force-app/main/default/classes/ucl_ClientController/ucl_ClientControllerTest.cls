@isTest
public class ucl_ClientControllerTest
{
    @isTest static void testGetClientCountByAdvisor()
    {
        Legal_Advisor__c legalAdvisor = new Legal_Advisor__c(
            Account_Number__c = 'a209ebbb-39c6-4852-8732-82237c0674fb',
            Account_Name__c = 'Fadeo',
            Account_Status__c = 'Enabled'
        );
        
        insert legalAdvisor;

        Client__c client = new Client__c(
            Legal_Advisor__c = legalAdvisor.Id,
            First_Name__c = 'Fran',
            Last_Name__c = 'Ruddick',
            Email__c = 'fruddick0@issuu.com',
            Phone__c = '390-285-2477',
            Address__c = '434 Maple Drive',
            Client_Number__c = '12afa152-8115-492b-bb49-87399ab49af8',
            CreatedByUser__c = false
        );
        
        insert client;

        Test.startTest();
        Integer clientCount = ucl_ClientController.getClientCountByAdvisor(legalAdvisor.Id);
        Test.stopTest();

        System.assertEquals(1, clientCount, 'The number of Client__c records should be 1');
    }
}