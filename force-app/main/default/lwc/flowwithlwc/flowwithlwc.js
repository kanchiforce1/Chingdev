import { LightningElement, api, track } from 'lwc';
import {
    FlowAttributeChangeEvent,
    FlowNavigationNextEvent,
} from 'lightning/flowSupport';

export default class Todos extends LightningElement {
    @api
    availableActions = [];

    @api
     todos
       
    @api todos1;

   

    handleUpdatedText(event) {
       // event.preventDefault();
       // this.todos1 = event.detail.value;
    }

    handleAddTodo() {
      //  this._todos.push(this._text);
       console.log(JSON.stringify(this.todos1));
        // notify the flow of the new todo list
        const attributeChangeEvent = new FlowAttributeChangeEvent(
            'todos1',
            this.todos1
        );
        this.dispatchEvent(attributeChangeEvent); 
    }

    handleGoNext() {
        this.todos1 = 'testdsdsddsetst';
        // check if NEXT is allowed on this screen
        if (this.availableActions.find((action) => action === 'NEXT')) {
            // navigate to the next screen
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        }
    }
}