import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="students"
export default class extends Controller {
  connect() {

 
    $('#dataTable').DataTable();
 


  }
}
