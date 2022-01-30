/* eslint-disable eqeqeq */
/* eslint-disable no-alert */
/* eslint-disable no-console */
import { LightningElement, wire , track} from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';

import { registerListener, unregisterAllListeners, fireEvent } from 'c/pubsub';

export default class TitleMetaComponent extends LightningElement {

  @track titleId; btnToggle = {
    transimittalBtn: false,
    chinookBtn: false,
    cbBtn: false
  };
  
  martyId; selectTitle; urlParameters; servicesCount;

  renderedCallback() {

    //console.log(this.PTFUsers);
    try {
    if (this.stopRenderCallBack == false && this.titleId) {
     // alert(this.stopRenderCallBack);
      this.template.querySelector('[data-id="Transmittal"]').classList.add('redColor');
      this.template.querySelector('[data-id="Chinook"]').classList.add('redColor');
      this.template.querySelector('[data-id="CB"]').classList.add('redColor');
    }
  }catch(e) {console.log(e.message);}
  }
  connectedCallback() {
   
   /* let url = window.location.search;

    let vars = url.replace('?', '').split("&");
    let urlParams = {};
    let titleId, v;
    for (let i = 0; i < vars.length; i++) {

      let pair = vars[i].split("=");

      if (pair[0] == 'titleId')
        titleId = pair[1];

      if (pair[0] == 'v')
        v = pair[1];

    }
    urlParams.titleId = titleId;

    urlParams.v = v;
    this.urlParameters = urlParams;

    console.log(JSON.stringify(this.urlParameters)); */

    // subscribe to searchKeyChange event
    
    registerListener('selectedtitle', this.handleSearchKeyChange, this);
  }

  disconnectedCallback() {
    // unsubscribe from searchKeyChange event
    unregisterAllListeners(this);
  }

  stopRenderCallBack = false;
  handleSearchKeyChange(selecttitle) {
    if(selecttitle) {
      console.log('selecttitle'+ JSON.stringify(selecttitle));
     // alert('hii');
      this.titleId = selecttitle.Id;
      setTimeout(() => {
    this.stopRenderCallBack = true;
    
    this.martyId = selecttitle.MartyId;
    this.selectTitle = selecttitle;
    this.btnToggle = selecttitle.btnToggle;
    if (this.urlParameters)
      if (this.urlParameters.v)
        this.urlParameters.v = selecttitle.vendor;
    console.log('this.btnToggle' + JSON.stringify(this.btnToggle));
    debugger
    if (this.btnToggle) {
      this.servicesCount = selecttitle.btnToggle.servicesCount;
     

      if (this.btnToggle.transimittalBtn && this.btnToggle.transimittalBtn == true) {
        var tra = this.template.querySelector('[data-id="Transmittal"]');
        if(tra) {
          tra.classList.remove('redColor');
          tra.classList.add('redColor1');
          tra.classList.add('cursorPoint');
          tra.classList.remove('hide');
        }

      } else {

        var tra = this.template.querySelector('[data-id="Transmittal"]');
        if(tra){
        tra.classList.remove('redColor1');
        tra.classList.add('redColor');
        tra.classList.remove('cursorPoint');
        tra.classList.add('hide');

        }

      }
      if (this.btnToggle.chinookBtn && this.btnToggle.chinookBtn == true) {
        var Chinook = this.template.querySelector('[data-id="Chinook"]');
        if(Chinook) {
          Chinook.classList.remove('redColor');
          Chinook.classList.add('redColor1');
          Chinook.classList.add('cursorPoint');
        }


      } else {
        var Chinook = this.template.querySelector('[data-id="Chinook"]');
        if(Chinook) {
        Chinook.classList.remove('redColor1');
        Chinook.classList.add('redColor');
        Chinook.classList.remove('cursorPoint');
        }

      }

      if (this.btnToggle.cbBtn && this.btnToggle.cbBtn == true) {
        var CB = this.template.querySelector('[data-id="CB"]');
        if(CB) {
        CB.classList.remove('redColor');
        CB.classList.add('redColor1');
        CB.classList.add('cursorPoint');
        }

      }
      else {
        var CB = this.template.querySelector('[data-id="CB"]');
        if(CB) {
        CB.classList.remove('redColor1');
        CB.classList.add('redColor');
        CB.classList.remove('cursorPoint');
        }
    

      }

    }
  //  console.log('page' + this.selectTitle.page);
   // console.log('page' + selecttitle.page);
    if(this.selectTitle.page) {
        this.buttonClickAction(true, this.selectTitle.page);
    }
  }, 400);
  }
  }

  /*  buttonDisabled(idVal) {
      this.template.querySelector(idVal).style.background = 'red';
      // this.template.querySelector('[data-id="Transmittal"]').disabled = false;
      this.template.querySelector(idVal).classList.remove('cursorPoint');
  
    } */

  /* buttonEnable(idVal) {
     this.template.querySelector(idVal).style.background = 'red';
     // this.template.querySelector('[data-id="Transmittal"]').disabled = false;
     this.template.querySelector(idVal).classList.remove('cursorPoint');
 
   } */
  @wire(CurrentPageReference) pageRef;

  handleClick(event) {
    // e.stopPropagation();  this.btnToggle
    console.log(JSON.stringify(this.selectTitle));
    console.log(JSON.stringify(event.currentTarget.dataset.id));
    var btnName = event.currentTarget.dataset.id;
    var btnActionFlg = false;
    //this.buttonClickAction(btnActionFlg,btnName);
    if (btnName == 'Transmittal' && this.btnToggle.transimittalBtn == true)
    btnActionFlg = true;
    if (btnName == 'Chinook' && this.btnToggle.chinookBtn == true)
      btnActionFlg = true;
    if (btnName == 'CB' && this.btnToggle.cbBtn == true)
      btnActionFlg = true;

    if (btnActionFlg == true) {
      if (btnName) {
        let dataWrp = {
          'Id': this.selectTitle.Id,
          'MartyId': this.selectTitle.MartyId,
          'fullTitleName': this.selectTitle.fullTitleName,
          'isSeries': this.selectTitle.isseries,
          'Name': this.selectTitle.Name,
          'btnName': btnName,
          'vendor': this.selectTitle.vendor.data,
        
        }
        console.log(JSON.stringify(dataWrp));
        fireEvent(this.pageRef, 'clickButton', dataWrp);
      }
    }
  }

  buttonClickAction(btnActionFlg, btnName) {
  
    if (btnName == 'Transmittal' && this.btnToggle.transimittalBtn == true)
      btnActionFlg = true;
    if (btnName == 'Chinook' && this.btnToggle.chinookBtn == true)
      btnActionFlg = true;
    if (btnName == 'CB' && this.btnToggle.cbBtn == true)
      btnActionFlg = true;

   
  }



}