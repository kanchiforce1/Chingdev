import { LightningElement, api } from 'lwc';

export default class TitleProjectteam extends LightningElement {

    @api titleId;
    @api title;
    @api series;

    connectedCallback() {
        this.title = this.series? this.series : this.title;
    }
    renderedCallback() {
      
    }
}