// GPS menu
$(document).on("ready", function(){
	$("#gps-menu").hide();
	$(".menu-btn-mainMenu").on("click", openGPS);
	$(".close-gps").on("click", closeGPS);
})

$(document).keyup(function(e) {
	//if ESC key is pressed
  if (e.keyCode == 27) {
  	closeGPS();
  }
});

function openGPS() {
  $("#gps-menu").fadeIn(400, function() {
    $(".menu-gps").flashScreen();	
  });
}

function closeGPS() {
	$("#gps-menu").hide();
	$(".menu-gps").css({
		display: "none"
	});
}

