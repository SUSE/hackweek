/* Parallax background - by
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

// background layers moving when the mouse is moving
var screenWidthMiddle = 0;
var bgLeftMargin = 0;
var movementX = 0;

$(window).on("load", function(){
  screenWidth = $(window).width();
  bgWidth = $(".bg-stars").width();
  bgLeftMargin =  -((bgWidth - screenWidth) / 2);
	screenWidthMiddle = screenWidth / 2;
	//movement of bg-stars. First layer
  movementParallax(".bg-stars", 1);
	//movement of bg-small-stars. Second layer
	movementParallax(".bg-small-stars", 1.5);
	//movement of the nebulas
	movementParallax(".nebula-up", 2.5);
	movementParallax(".nebula-down", 3);
});

$(document).mousemove(function(event){
	moveElementsBg(event);
});

var currentElementLastX = 0;
var movementParallaxElements = {};

function movementParallax (element, speed) {

  movementParallaxElements[element] = {
		"speed" : speed,
		"xCoordenate" : 0,
		"lastXposition": 0
	}
	$(element).css({
		left: bgLeftMargin
	})

}
function moveElementsBg(event) {
	$.each(movementParallaxElements, function(index,val){
		// the element has properties saved in the object
    if (val.lastXposition != event.pageX) {
		  if(event.pageX > screenWidthMiddle) {
		  	if(event.pageX > val.lastXposition) {
		  	  val.xCoordenate = val.xCoordenate - val.speed;
		  	} else {
		  		val.xCoordenate = val.xCoordenate + val.speed;
		  	}
		  	movementX = bgLeftMargin + val.xCoordenate;
		  	if (val.xCoordenate > bgLeftMargin){
			  	$(index).css({
			  		left: movementX
			  		});
		  	}
		  }
		  if(event.pageX < screenWidthMiddle) {
		  	if(event.pageX < val.lastXposition) {
			    val.xCoordenate = val.xCoordenate + val.speed;
		  	} else {
		  		val.xCoordenate = val.xCoordenate - val.speed;
		  	}
		  	movementX = bgLeftMargin + val.xCoordenate
		  	
		  	$(index).css({
		  		left: movementX
		  		});
		  }
		  val.lastXposition = event.pageX;
	  }
  })
}
var gyro = 0;


function moveElementsBgMobile(event) {
  if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
	  gyro = event.beta;
	} else {
		gyro = event.gamma;
	}
	$.each(movementParallaxElements, function(index,val){
    // when the screen is turned to the left
	  if(gyro < -1) {
	  	val.xCoordenate = val.xCoordenate - gyro / 5 * val.speed;
	  	movementX = bgLeftMargin + val.xCoordenate;
	  	if (-(val.xCoordenate) > bgLeftMargin) {
		  	$(index).css({
		  		left: movementX
		  		});
	  	} else {
	  		val.xCoordenate = val.xCoordenate + gyro / 5 * val.speed;
	  	}
	  	val.lastXposition = movementX;
	  }
	  // when the screen is turned to the right
	  if(gyro > 1) {
		  val.xCoordenate = val.xCoordenate - gyro / 5 * val.speed;
	  	movementX = bgLeftMargin + val.xCoordenate
	  	if (val.xCoordenate > bgLeftMargin) {
		  	$(index).css({
		  		left: movementX
		  		});	
	  	} else {
	  		val.xCoordenate = val.xCoordenate + gyro / 5 * val.speed;
	  	}
	  	val.lastXposition = movementX;
	  }
		  
  })
}

window.addEventListener('deviceorientation', moveElementsBgMobile);
