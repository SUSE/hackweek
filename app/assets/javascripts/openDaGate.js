/* openDaGate - by
╱╱╱╱╱╱╱╱╱╱╭╮╭╮╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╭╮
╱╱╱╱╱╱╱╱╱╭╯╰┫┃╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱┃┃
╭━━┳╮╱╭┳━╋╮╭┫╰━┳┳━━╮╭━━┳━━┳━╮╭━━┫╰━┳━━┳━━━╮
┃╭━┫┃╱┃┃╭╮┫┃┃╭╮┣┫╭╮┃┃━━┫╭╮┃╭╮┫╭━┫╭╮┃┃━╋━━┃┃
┃╰━┫╰━╯┃┃┃┃╰┫┃┃┃┃╭╮┃┣━━┃╭╮┃┃┃┃╰━┫┃┃┃┃━┫┃━━┫
╰━━┻━╮╭┻╯╰┻━┻╯╰┻┻╯╰╯╰━━┻╯╰┻╯╰┻━━┻╯╰┻━━┻━━━╯
╱╱╱╭━╯┃/////////////////////////////////////
╱╱╱╰━━╯http://cynt.co.nf////////////////////
////////////////////////////////////////////
*/
// javascript to open the gates as a splash screen
$(window).on("load", function(){
  gatesSize();
})
$(window).on("resize", function(){
  gatesSize();
})
$(document).on("ready", function(){
  $("#home-menu-contact").css({
    bottom: "-450px"
  });
})

var gateSize = 450;
var gatesOpened = false;

function gatesSize() {
  gateSize = ($(window).height() / 2) + ($(window).height() *13 /100);
  $(".upper-gate").css({
    height : gateSize + "px"
  });
  $(".lower-gate").css({
    height : gateSize + "px"
  });
  openDaGate();
}
function openDaGate() {
  if (!screenPortrait() && !gatesOpened) {
    setTimeout(function() {
  	  $(".lower-gate").animate({
  	  	bottom: "-"+gateSize+"px"
  	  },3500);
  	  $(".upper-gate").animate({
  	  	top: "-"+gateSize+"px"
  	  },3500, function(){
  	  	$("#splash").remove();
  	  	initiateSpaceshipScreen();
  	  });
    }, 2500);
    gatesOpened =  true;
  }
}

function initiateSpaceshipScreen () {
  $("#home-menu-contact").animate({
  	bottom: "0"},
  	800, function() {
  	/* stuff to do after animation is complete */
  	setTimeout(function(){
  	  $("#left-menu").flashScreen();	
  	}, 200);
  	$("#right-menu").flashScreen();
  	$(".mainScreen").fadeIn(400);
  });
}

$.fn.extend({
  flashScreen: function() {
    var flashTime = {
    	30: [0.2],
    	45: [0.2],
    	55: [0.2],
    	70: [0.3],
    	90: [0.5],
    	130: [0.5],
    	180: [0.5],
    	230: [0.5],
    	280: [0.8],
    	350: [0.8],
    	440: [0.8],
    	500: [1],
    	570: [1]
    }
  	var element = $(this);
  	var flashCss = "visible";
  	var i = 0;
  	$.each(flashTime, function(index, val) {
      i++;
      if ( i % 2 == 0) {
	      flashCss = "none";
	      setTimeout(function() {
	  			$(element).css({
	  				display: flashCss,
	  				opacity: 0
	  			});
	  		}, index);
	    }
	    else {
	    	flashCss = "block";
	    	setTimeout(function() {
	  			$(element).css({
	  				display: flashCss,
	  				opacity: val[0]
	  			});
	  		}, index);
	    }
  		
  	});

  }
});

