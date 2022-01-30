/* eslint-disable no-alert */
/* eslint-disable eqeqeq */
/* eslint-disable no-console */
import { LightningElement, api } from 'lwc';

export default class Ppw_serviceBasedMapValues extends LightningElement {
@api key1;
value;formate;servicePrep;digitalOrEbook;paperBackOrHandOver;asin;isbn_13;trim_height;trim_width;
interior_paper_stock;initial_page_count;
@api type;
@api smap;
connectedCallback() {
  
    console.log(JSON.stringify(this.key1));
   
    if(this.smap)
        this.value = this.smap[this.key1];
        console.log('this this++'+ JSON.stringify(this.value));
    if(this.type == 'formate')  {   
        this.formate = true;
      
    }
    if(this.type =='servicePrep') { 
        
        this.servicePrep = true;
      
       
    }
   
}
opensection() {

  //alert('hii');
   let s1 = this.template.querySelector('[data-id="section1"]');
    s1.classList.toggle('slds-is-open');
}

}