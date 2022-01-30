/* eslint-disable no-console */
import { LightningElement,api } from 'lwc';

export default class Ppw_AsinConditions extends LightningElement {

value;formate;servicePrep;digitalOrEbook;paperBackOrHandOver;asin;isbn_13;trim_height;trim_width;
interior_paper_stock;initial_page_count;

@api value;
connectedCallback() {
  
    if(this.value) {
     console.log('value'+JSON.stringify(this.value));
        let x = this.value; 
        this.asin = x.ASIN__c != null;
        this.isbn_13 = x.ISBN_13__c != null;
        this.trim_height = x.Trim_Height__c != null;
        this.interior_paper_stock = x.Interior_Paper_Stock__c != null;
        this.initial_page_count = x.Initial_Page_Count__c != null;
        this.paperBackOrHandOver = (x.Name == 'Paperback' || x.Name == 'Hardcover');
        this.trim_width = x.Trim_Width__c != null;
    }
      
}

}