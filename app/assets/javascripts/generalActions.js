// this documents has small general actions for buttons and other things in Interstellar
$(document).on("ready", function(){
	$(".show-search-btn").on("click", function(){
		$(this).fadeOut('400', function() {
			$(".projects-search-form").fadeIn(400);
		});
	})
})