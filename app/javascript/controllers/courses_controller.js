import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="courses"
export default class extends Controller {
  connect() {

    console.log("Courses Java Script")

    $('#fade-out').fadeOut(4000)
 

  

  }
}
