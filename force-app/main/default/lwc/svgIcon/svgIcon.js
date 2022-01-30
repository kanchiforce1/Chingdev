// myComponent.js
import { LightningElement,api ,track} from 'lwc';
import SVG_LOGO from '@salesforce/resourceUrl/Svg_Icons';///utility-sprite/svg/symbols';

export default class myComponent extends LightningElement {
    @api svgicon;
    @api styleClass;
    @api stylec;
    @api width;
    @api height;
   
   get svgURL() {
    return `${SVG_LOGO}`+ this.svgicon;
}

 
get wdt() {

  return this.width;
}

 
get hgt() {
 
  return this.height;
}
  
}