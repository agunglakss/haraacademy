import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="menu"
export default class extends Controller {

  hamburger() {
    document.getElementById('popUpMobile').classList.add('active')
  }

  close() {
    document.getElementById('popUpMobile').classList.remove('active')
  }

  expand(e) {
    e.preventDefault();
    console.log(e.target.open);
  }
  
}
