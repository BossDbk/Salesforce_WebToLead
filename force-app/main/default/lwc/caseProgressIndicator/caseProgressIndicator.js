import { LightningElement, wire, api} from 'lwc';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import STATUS_FIELD from '@salesforce/schema/Case.Status';
import CASE_ID from '@salesforce/schema/Case.Id';
import CASE_STATUS from '@salesforce/schema/Case.Status';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import { getFieldValue, getRecord, updateRecord } from 'lightning/uiRecordApi';
import {
    subscribe,
    unsubscribe,
    onError,
    setDebugFlag,
    isEmpEnabled,
} from 'lightning/empApi';
export default class CaseProgressIndicator extends LightningElement {
    statusOptions
    @api recordId
    caseStatusValue
    channelName = '/event/Case_Detail__e';
    subscription
        @wire(getObjectInfo, {
            objectApiName: CASE_OBJECT
        }) objectInfo;

        @wire(getPicklistValues, {
            recordTypeId: '$objectInfo.data.defaultRecordTypeId',
            fieldApiName: STATUS_FIELD
        }) picklistValues({data,error}){
            if(data){
                console.log('picklistValues:',data);
                this.statusOptions = data.values;
            } else if(error){
                console.log('Error while Fetching Picklist Values',error);
            }
        }

        @wire(getRecord, {
                    recordId: '$recordId',
                    fields: [STATUS_FIELD]
                }) getRecordOutput ({error, data}){
            if(data){
                console.log('wiredRecord:',data);
                this.caseStatusValue = getFieldValue(data, STATUS_FIELD);
            } else if(error){
                console.log('Error while Fetching Record',error);
            }
        }

    // Initializes the component
    connectedCallback() {
        this.handleSubscribe();
        // Register error listener
        this.registerErrorListener();
    }

    // Cleans up the component
    disconnectedCallback() {
        this.handleUnsubscribe();
    }
    // Handles subscribe button click
    handleSubscribe() {
        // Callback invoked whenever a new event message is received
        const messageCallback = (response) => {
        this.handleEventResponse(response);
        };
        // Invoke subscribe method of empApi. Pass reference to messageCallback
            subscribe(this.channelName, -1, messageCallback).then((response) => {
                    // Response contains the subscription information on subscribe call
                    console.log(
                        'Subscription request sent to: ',
                        JSON.stringify(response.channel)
                    );
                    this.subscription = response;
            });
        }
    registerErrorListener() {
        // Invoke onError empApi method
        onError((error) => {
            console.log('Received error from server: ', JSON.parse(JSON.stringify(error)));
            // Error contains the server-side error
        });
    }

    handleUnsubscribe() {
        // Invoke unsubscribe method of empApi
        unsubscribe(this.subscription, (response) => {
            console.log('unsubscribe() response: ', JSON.parse(JSON.stringify(response)));
            // Response is true for successful unsubscribe
        });
    }

    async handleEventResponse(response){
    console.log('Event message received: ', JSON.parse(JSON.stringify(response)));
        if(response.hasOwnProperty('data')){
            let jsonObj = response.data;
            if(jsonObj.hasOwnProperty('payload')){
                jsonObj = jsonObj.payload;
                let caseStatusValue = jsonObj.Case_Status__c;
                let caseId = jsonObj.Case_ID__c;
        
            let fields = {};
            fields[CASE_ID.fieldApiName] = caseId;
            fields[CASE_STATUS.fieldApiName] = caseStatusValue;
            let recordInput = {fields};
            
            await updateRecord(recordInput);
            await notifyRecordUpdateAvailable([{recordId: this.recordId}]);
            
            const event = new ShowToastEvent({
                title: 'Case Updated',
                message: 'Case Status has been updated to '+caseStatusValue,
                variant: 'success',
            });

            this.dispatchEvent(event);

            }
        }
    }
}
