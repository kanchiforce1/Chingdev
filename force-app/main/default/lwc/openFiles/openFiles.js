// openFileSample.js
import { LightningElement,track,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import WEBSITE_FIELD from '@salesforce/schema/Account.Website';
import REVENUE_FIELD from '@salesforce/schema/Account.AnnualRevenue';


export default class OpenFileSample extends NavigationMixin(LightningElement) {

    @track fieldName = NAME_FIELD;
    navigateToFiles() {
      this[NavigationMixin.Navigate]({
        type: 'standard__namedPage',
        attributes: {
            pageName: 'filePreview'
        },
        state : {
            recordIds: '0691H000007lbAN',
            selectedRecordId:'0691H000007lbAN'
        }
      })
    }

      accountObject = ACCOUNT_OBJECT;
     myFields = [NAME_FIELD, WEBSITE_FIELD];
     fieldName = NAME_FIELD;
     
    handleSubmit(event) {
        console.log(event.detail);
    }
    handleSuccess(event) {
        console.log('Record iD' + event.detail.id);

    }
    @api objectApiName;

    fields = [NAME_FIELD, REVENUE_FIELD];

    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: "Account created",
            message: "Record ID: " + event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(evt);
    }

}