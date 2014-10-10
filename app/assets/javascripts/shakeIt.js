/* shake the screen - by
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

//javascript testing shaking screen
var screenWidth = 0;
var screenHeight = 0;
var initialX = -450;
var initialY = -500;

$(window).on("load", function() {
	//setup of asteroids position
	//get initial screen resolution
  screenWidth = $(window).width();
	screenHeight = $(window).height();
	$(".asteroid").css({
    "top": initialX,
    "right": initialY,
    "display": "block"
	});
	setTimeout(asteroidPassing, shakeTimeInterval());
})
$(window).resize(function() {
	//get screen resolution after window resized
	screenWidth = $(window).width();
	screenHeight = $(window).height();
});

function shakeTimeInterval() {
	var valueTime = Math.floor((Math.random() * 40000) + 45000);
	return valueTime;
}

var rotationObj = {
	30: [0,1,1],
	60: [0,-1,-1],
	90: [0,1,1],
	120: [0,-1,-1],
	150: [0,1,1],
	180: [0,-1,-1],
	210: [0,2,2],
	240: [0.4,-2,-2],
	270: [-0.4,1,1],
	300: [0.4,-2,-2],
	330: [0,2,2],
	360: [0.4,-2,-2],
	390: [-0.4,2,2],
	420: [0,-2,-2],
	450: [0.4,3,3],
	480: [0,-3,-3],
	510: [0.4,3,3],
	540: [-0.8,-3,-3],
	570: [0,3,3],
	600: [0.8,-3,-3],
	630: [0,3,3],
	660: [0.8,-3,-3],
	690: [-0.6,3,3],
	720: [1,-4,-4],
	750: [0,4,4],
	780: [1,-4,-4],
	810: [-1,4,4],
	840: [1,-4,-4],
	870: [0,4,4],
	900: [0,-5,-5],
	930: [1.4,5,5],
	960: [-1.4,-5,-5],
	990: [0,5,5],
	1020: [1.5,-5,-5],
	1050: [0,5,5],
	1080: [1.5,-5,-5],
	1110: [-1.5,5,5],
	1140: [0,-5,-5],
	1170: [1.3,4,4],
	1200: [0,-4,-4],
	1230: [1,4,4],
	1250: [-1,-4,-4],
	1280: [1,3,3],
	1310: [0,-3,-3],
	1340: [1,3,3],
	1370: [-1,-3,-3],
	1400: [0,3,3],
	1080: [1,-3,-3],
	1110: [-1,2,2],
	1140: [0,-2,-2],
	1170: [1,2,2],
	1200: [0,-2,-2],
	1230: [1,2,2],
	1250: [0,-1,-1],
	1280: [0,1,1],
	1310: [0,-1,-1],
	1340: [0,1,1],
	1370: [0,-1,-1],
	1400: [0,0,0]
}
//function that shakes the screen
function screenShaker() {
	setTimeout(function() {
		$.each(rotationObj, function(index, val) {
			 setTimeout(function() {
			 	$(".container").css({
			 		"transform": "rotate("+val[0]+"deg)",
		      "-ms-transform": "rotate("+val[0]+"deg)",
		      "-webkit-transform": "rotate("+val[0]+"deg)",
		      top: val[1],
		      right: val[2]
			 	})
			 }, index);
		});
	}, 1500)
}
//function that makes the asteroid show on screen
function asteroidPassing() {
	screenShaker();
	$(".asteroid").animate({
		top: screenHeight-200,
		right: screenWidth+250},
		5000, function() {
		  setTimeout(asteroidPassing, shakeTimeInterval());
		  $(".asteroid").css({
		    "top": initialX,
		    "right": initialY
			});
	});
}

