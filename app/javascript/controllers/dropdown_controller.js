import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets= ["drop"]

  connect() {
    console.log("salut");
  }

  drop() {
    this.dropTarget.classList.remove("d-none")
  }
}
