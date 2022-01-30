/* eslint-disable no-alert */
/* eslint-disable no-console */
import { LightningElement,wire,track } from 'lwc';
import { CurrentPageReference} from 'lightning/navigation';
import getTitleData from '@salesforce/apex/PPW_transmittalController_lwc.getTitleData';
import getSeriesData from '@salesforce/apex/PPW_transmittalController_lwc.getSeriesData';
// eslint-disable-next-line no-unused-vars
import { registerListener, unregisterAllListeners} from 'c/pubsub';


export default class TitleMetaComponent extends LightningElement {

    @track titleId;
    @track titleD;
    @track seriesD;
    @track btnToggle;
  
    connectedCallback() {
     
      registerListener('selectedtitle', this.handleGetTitleData, this);
     
  }

  disconnectedCallback() {
  
     // unregisterAllListeners(this);
  }
  @wire(CurrentPageReference) pageRef;
  async handleGetTitleData(selecttitle) {
      console.log('selecttitle'+JSON.stringify(selecttitle));
      
      this.titleId = selecttitle.Id;
      if(selecttitle.isseries)
        this.seriesD = await getSeriesData({seriesId: selecttitle.Id});
      else
          this.titleD = await getTitleData({titleId: selecttitle.Id });
      console.log(this.seriesD);
      this.btnToggle = selecttitle.btnToggle;
      let rejectMenu = this.template.querySelector('[data-id="status"]'); 
      if (rejectMenu)
        rejectMenu.classList.add('textSize');// slds-is-open
     
 
  }
 
       

}