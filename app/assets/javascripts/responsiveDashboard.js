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
	$(".mainScreen").css({
		height: windowHeight - homeButtonHeight - 20 + "px" //20 is to give it a padding
	})
}