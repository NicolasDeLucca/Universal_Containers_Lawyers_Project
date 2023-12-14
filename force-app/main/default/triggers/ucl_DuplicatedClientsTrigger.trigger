trigger ucl_DuplicatedClientsTrigger on Client__c (before insert)
{
    Set<String> primaryKeys = new Set<String>();
    List<Client__c> clientsInDb =
    [
        SELECT PrimaryKey__c
        FROM Client__c
    ];
    
    for (Client__c c: clientsInDb)
    {
        primaryKeys.add(c.PrimaryKey__c);
    }
    
    for (Client__c client : Trigger.New)
    {
        if (primaryKeys.contains(client.PrimaryKey__c))
        {
           client.addError(''); 
        }
    }
}