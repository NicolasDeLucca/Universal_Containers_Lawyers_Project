public with sharing class ucl_ClientController
{
    @AuraEnabled(cacheable=true)
    public static Integer getClientCountByAdvisor(Id advisorId)
    {
        return [SELECT COUNT() FROM Client__c WHERE Legal_Advisor__c = :advisorId];
    }
}