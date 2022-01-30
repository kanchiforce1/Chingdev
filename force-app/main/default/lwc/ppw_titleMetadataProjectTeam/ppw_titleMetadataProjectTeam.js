import { LightningElement, api } from 'lwc';

export default class ppw_titleMetadataProjectTeam extends LightningElement {
    @api titleId;

    renderedCallback() {
       console.log(this.titleId)
    }
}