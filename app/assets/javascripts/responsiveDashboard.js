// responsive layout
$(window).on("load", function(){
	layoutResponsive();
})
$(window).on("resize", function(){
  layoutResponsive();
});

function layoutResponsive () {
	var windowHeight = $(window).height();
	var homeButtonHeight = $("#home-menu-contact").height();
	var flashHeight = $("#flash").height(); 
        if (flashHeight > 1) {
          flashHeight = flashHeight + 40 // 35 is the margin
        }
	var announcementHeight = $("#announcement").height();
        if (announcementHeight > 1) {
          announcementHeight = announcementHeight + 50 // 35 is the margin
        }

	$(".mainScreen").css({
		height: windowHeight - flashHeight - announcementHeight - homeButtonHeight - 20 + "px" //20 is to give it a padding
	})
}
