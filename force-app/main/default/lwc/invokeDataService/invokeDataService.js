import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import migrateData from '@salesforce/apex/ucl_DataMigration.migrateData';
import handleError from '@salesforce/apex/ucl_ErrorHandler.handleError';

export default class invokeDataService extends LightningElement
{
    handleClick()
    {
        migrateData()
        .then(result =>
        {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Data migration is running',
                    variant: 'success',
                }),
            );
        })    
        .catch(error =>
        {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error',
                })
            )
            
            handleError(error.body.message);   
        });    
    }
}