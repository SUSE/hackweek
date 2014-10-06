// mainscreen resizer
$(window).on("load", function(){
  mainWrapResizer();
})
$(window).on("resize", function(){
  mainWrapResizer();
})

function mainWrapResizer () {
	var windowWidth = $(window).width();
	var menuSize = 233 * 2;
	var paddingWrap = 15;
	var finalWrapSize = windowWidth - menuSize;
	$(".mainscreen-wraper").css({
		width: finalWrapSize + "px",
		"padding-left": paddingWrap + "px",
		"padding-right": paddingWrap + "px"
	});
}
