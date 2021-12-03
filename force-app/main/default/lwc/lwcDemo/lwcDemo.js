import { LightningElement, wire, track } from "lwc";
import getAccounts from "@salesforce/apex/AccountController.getAccounts";
import getAccountDetails from "@salesforce/apex/AccountController.getAccountDetails";


export default class LwcDemo2 extends LightningElement {
  accountRecords;
  displayDetails = false;
  accountId;
  accountDetails;
  error;
  profileUrl;
  setSpinner = false;

  columns = [{label:'Name',fieldName:'Name',type:'text'},
             {label:'Industry',fieldName:'Industry',type:'text'},
             {label:'Type', fieldName: 'Type', type:'text'},
             {label:'Owner', fieldName: 'Owner.Name', type:'text'},
             //{label:'Profile Phone', fieldName:'Owner.SmallPhotoUrl', type:'Url', typeAttributes:{label: { fieldName: 'Owner.SmallPhotoUrl' }}},
            ];

  @wire(getAccounts)
  wiredRecord({ error, data }) {
    if (data) {
      this.accountRecords = data;
    } else if (error) {
      console.log("Error: " + error.message);
    }
  }

  handleClick(event) {
    this.accountId = event.currentTarget.dataset.id;
  }

  
  showDetails() {
    this.setSpinner = true;
    getAccountDetails({accountId: this.accountId})
        .then(result=>{
            this.accountDetails = result;
            this.displayDetails = true;
            this.setSpinner = false;
        })
        .catch(error=>{
            this.errors = error;
            this.setSpinner = false;
            alert('error = ' + this.error);
        });
  }

  hideDetails() {
      this.displayDetails = false;
  }

}