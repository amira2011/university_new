// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
 
import "@hotwired/turbo-rails"
import "controllers"
import "popper"
import "@fortawesome/fontawesome-free";
//= require jquery
//= require bootstrap
import "jquery"
import "jquery_ujs"
import "./jquery_ui"
import "bootstrap"
import "./plugins/sb-admin-2"
console.log($); // ok
console.log("hi abid"); // ok

 
$(".notice").fadeOut(4000)
 