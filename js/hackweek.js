$(function () {


    $("#start-link").click(function () {
        $('html, body').animate({
            scrollTop: $("#start").offset().top
        }, 1000);
    })

    $("#what-is-link, #arrow-start").click(function () {
        $('html, body').animate({
            scrollTop: $("#what-is").offset().top
        }, 1000);
    })

    $("#projects-link").click(function () {
        $('html, body').animate({
            scrollTop: $("#projects").offset().top
        }, 1000);
    })

    $("#agenda-link").click(function () {
        $('html, body').animate({
            scrollTop: $("#agenda").offset().top
        }, 1000);
    })

    $("#join-link").click(function () {
        $('html, body').animate({
            scrollTop: $("#join").offset().top
        }, 1000);
    })

    $("#where-link").click(function () {
        $('html, body').animate({
            scrollTop: $("#where").offset().top
        }, 1000);
    })


    $(window).scroll(function () {

        /* hide - unhide navigation */
        if (!$('#navigation').is(":visible") && $(window).scrollTop() >= $('#what-is').height()/2) {
            $('#navigation').fadeIn()
        }
        if ($('#navigation').is(":visible") && $(window).scrollTop() < $('#what-is').height()/2) {
            $('#navigation').fadeOut()
        }


    })


});



