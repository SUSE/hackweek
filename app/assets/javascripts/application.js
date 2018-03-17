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
//= require jquery.table-filter.js
//= require jquery.swipebox.js

// to store clicked link
var clickedLink;

$(function() {
  // add a hash to the URL when the user clicks on a tab
  $('a[data-toggle="tab"]').on('click', function(e) {
    history.pushState(null, null, $(this).attr('href'));
  });
  
  // when history changes
  window.addEventListener("popstate", function(e) {
    // when history changes and poped state is a state that come from ajax so reload the whole page
    if (e.state != null){
      if(e.state.hasOwnProperty('isAjax')){
        location.reload();
      }
    }
    // navigate to a tab when the history changes
    else{
      var activeTab = $('a[href="' + location.hash + '"]');
      if (activeTab.length) {
        activeTab.tab('show');
      } else {
        $('.nav-tabs a').first().tab('show');
      }
    }
  });
});

$(function() {
    var hash = window.location.hash;
    hash && $('ul.nav a[href="' + hash + '"]').tab('show');
});

$(function() {
  $('#show-preview').click(
    function() {
      var text = $('.markdown-source-text').val();
      $.ajax('/markdown/preview.js?source=' + encodeURIComponent(text));
    });
});

$(function() {
  $('#show-source').click(
    setTimeout(
      function () {
        $('#preview-contents').addClass('hidden');
        $('#loading-spinner').removeClass('hidden');
      }, 200
    )
  );
});

// to add loader and opacity when ajax is start
$( document ).ajaxStart(function() {
  $("#content").css('opacity', '0.4');
  $( "#loader" ).show();

});

// to stop loader and remove opacity when ajax is stop
$( document ).ajaxStop(function() {
  $("#content").css('opacity', '');
  $( "#loader" ).hide();
});

// to get the link which will be used in ajax case for pushState
$(document).on("click", "a", function(){
  clickedLink = this.href;
})
