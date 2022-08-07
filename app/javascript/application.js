// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

// Bootstrap
import "bootstrap"
// jQuery
import "./src/jquery/jquery"
// Custom JS
import "./src/app"
// Testing hotwired
$(document).on("turbo:load", () => {
  console.log("Turbo Hotwired");
})

