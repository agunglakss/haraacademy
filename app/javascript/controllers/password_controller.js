import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="menu"
export default class extends Controller {

  show(e) {
    e.preventDefault();
    const password = document.getElementById('password')
    if (password.type === "password") {
      password.type = "text";
    } else {
      password.type = "password";
    }
  }
  
}