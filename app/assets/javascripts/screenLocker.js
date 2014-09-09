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
// screenLocker
var w = 0;
var h = 0;
var metaValue = "";

$(window).on("load", function(){
  screenPortrait();
});

$(window).on("resize", function(){
  screenPortrait();
});

function screenPortrait() {
	// hide the screeLocker by default
	$("#screenLock").hide();
	// get the browser size
	w = $(window).width();
  h = $(window).height();
  // if it doesnt comply with a aspect ratio 4:3 the screen is blocked
  if ( (w/4) < (h/3) ) {
  	// if width is small than height the screen is in portrait position
  	// therefor we lock the screen and show the corresponding message to the user
    $("#screenLock").show();
    // make the screen of the device zooom to 100% for the screen locked
    metaValue = 'initial-scale=1';
    $('meta[name=viewport]').attr('content', metaValue);
    return true;
  } else {
  	metaValue = '';
    $('meta[name=viewport]').attr('content', metaValue);
  	return false;
  }
}
