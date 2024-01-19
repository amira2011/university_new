import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="demo"
export default class extends Controller {
  connect() {

    console.log("Connected")
    $(".notice").fadeOut(4000)
  }
}
