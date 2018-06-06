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
//= require jquery.atwho
//= require mousetrap
//= require jquery-hotkeys
//= require bootstrap
//= require selectize
//= require jquery.table-filter.js
//= require jquery.swipebox.js
//= require jquery-ui/widgets/autocomplete
//= require autocomplete-rails

$(function() {
  // add a hash to the URL when the user clicks on a tab
  $('a[data-toggle="tab"]').on('click', function(e) {
    history.pushState(null, null, $(this).attr('href'));
  });
  // navigate to a tab when the history changes
  window.addEventListener("popstate", function(e) {
    var activeTab = $('a[href="' + location.hash + '"]');
    if (activeTab.length) {
      activeTab.tab('show');
    } else {
      $('.nav-tabs a').first().tab('show');
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

$(function(){
  var emojis = [
    "smile", "iphone", "girl", "smiley", "heart", "kiss", "copyright", "coffee",
    "a", "ab", "airplane", "alien", "ambulance", "angel", "anger", "angry",
    "arrow_forward", "arrow_left", "arrow_lower_left", "arrow_lower_right",
    "arrow_right", "arrow_up", "arrow_upper_left", "arrow_upper_right",
    "art", "astonished", "atm", "b", "baby", "baby_chick", "baby_symbol",
    "balloon", "bamboo", "bank", "barber", "baseball", "basketball", "bath",
    "bear", "beer", "beers", "beginner", "bell", "bento", "bike", "bikini",
    "bird", "birthday", "black_square", "blue_car", "blue_heart", "blush",
    "boar", "boat", "bomb", "book", "boot", "bouquet", "bow", "bowtie",
    "boy", "bread", "briefcase", "broken_heart", "bug", "bulb",
    "person_with_blond_hair", "phone", "pig", "pill", "pisces", "plus1",
    "point_down", "point_left", "point_right", "point_up", "point_up_2",
    "police_car", "poop", "post_office", "postbox", "pray", "princess",
    "punch", "purple_heart", "question", "rabbit", "racehorse", "radio",
    "up", "us", "v", "vhs", "vibration_mode", "virgo", "vs", "walking",
    "warning", "watermelon", "wave", "wc", "wedding", "whale", "wheelchair",
    "white_square", "wind_chime", "wink", "wink2", "wolf", "woman",
    "womans_hat", "womens", "x", "yellow_heart", "zap", "zzz", "+1",
    "-1"
  ];
  var emojis = $.map(emojis, function(value, i) {return {key: value, name:value}});
  var emoji_config = {
    at: ":",
    data: emojis,
    displayTpl: "<li>${name} <img src='https://assets-cdn.github.com/images/icons/emoji/${key}.png'  height='20' width='20' /></li>",
    insertTpl: ':${key}:',
    delay: 400
  }
  $('textarea').atwho(emoji_config);
});

function textcover(txtarea, newtxt) {
  $(txtarea).val(
        $(txtarea).val().substring(0, txtarea.selectionStart)+
        newtxt +
        $(txtarea).val().substring(txtarea.selectionStart,txtarea.selectionEnd)+
        newtxt +
        $(txtarea).val().substring(txtarea.selectionEnd)
   );  
}
