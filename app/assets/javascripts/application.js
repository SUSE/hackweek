// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require mousetrap
//= require jquery-hotkeys
//= require bootstrap
//= require selectize
//= require jquery.swipebox.js
//= require screenLocker.js
//= require openDaGate.js
//= require shakeIt.js
//= require spaceSurf.js
//= require ScrollBar.js
//= require perfect-scrollbar.js
//= require responsiveDashboard.js
//= require tweeter-reader.js
// fix incompatibility of bootstraps .hidden class with jquery show()
var show = $.fn.show;
$.fn.show = function() {
  this.removeClass('hidden');
  this.removeClass('hide');
  return show.call(this);
};


