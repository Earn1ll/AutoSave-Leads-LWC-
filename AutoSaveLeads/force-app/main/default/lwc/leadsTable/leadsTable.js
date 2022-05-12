import { LightningElement, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getLeads from '@salesforce/apex/LeadContactController.getLeads';
import updateValue from '@salesforce/apex/LeadContactController.updateLead';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const COLUMNS = [
    { label: 'Name', fieldName: 'URL', type: 'url', typeAttributes: {label: {fieldName: 'Name'}}, displayReadOnlyIcon: true},
    { label: 'Title', fieldName: 'Title', type: 'text', editable: true},
    { label: 'Phone', fieldName: 'Phone', type: 'phone', editable: true}
];

export default class LeadsTable extends LightningElement {
    columns = COLUMNS;
    records;
    refreshTable;
    error;
    saveDraftValues;
    id = '';
    title = '';
    phone = '';
    
    @wire (getLeads)
    wiredLeads (props) {
        const {data, error} = props;
        this.refreshTable = props;
        if (data) {
            this.records = data;
            this.records = this.records.map( row => {
                return { URL: '/lightning/r/Lead/' + row.Id + '/view',
                        Name: row.Name,
                        Title: row.Title, 
                        Phone: row.Phone, 
                        Id: row.Id
                }
            })
        }
        if (error) {
            this.error = 'Error ' + JSON.stringify(error);
        }
    }

    handleChangeAction(event) {
        this.saveDraftValues = event.detail.draftValues;
        this.id = this.saveDraftValues[0].Id;
        this.title = this.saveDraftValues[0].Title;
        this.phone = this.saveDraftValues[0].Phone;
        updateValue({id: this.id, title: this.title, phone: this.phone});
        this.template.querySelector('lightning-datatable').draftValues = [];
        clearTimeout(this.timeoutId);
        this.timeoutId = setTimeout(this.refreshData.bind(this),1000);
        const toastEvent = new ShowToastEvent({
            message: 'Success! Your changes are saved!',
            variant: 'success'
            });
        this.dispatchEvent(toastEvent);
    }

    refreshData() {
        refreshApex(this.refreshTable);
    }
}