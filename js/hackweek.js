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
            $('#arrow-start').fadeOut()

        }
        if ($('#navigation').is(":visible") && $(window).scrollTop() < $('#what-is').height()/2) {
            $('#navigation').fadeOut()
            $('#arrow-start').fadeIn()
        }

        /* start page text animation */
        if ($(window).scrollTop() <= $('#start').height()) {
            var percent_scrolled_out = $(window).scrollTop() / $('#start').height()
            $("#claim-line1").css({ top: $(window).scrollTop() - (percent_scrolled_out * $("#claim-line1").position().top) / 6 });
            $("#claim-line1").css({ 'opacity' : 1-percent_scrolled_out });
            $("#claim-line2").css({ top: $(window).scrollTop() - (percent_scrolled_out * $("#claim-line2").position().top) / 6 });
            $("#claim-line2").css({ 'opacity' : 1-percent_scrolled_out });
            $("#claim-line3").css({ top: $(window).scrollTop() - (percent_scrolled_out * $("#claim-line3").position().top) / 6 });
            $("#claim-line3").css({ 'opacity' : 1-percent_scrolled_out });

        }
    })


    if ($(window).scrollTop() == 0) {
        $("#claim-line1").css({ right: $(window).width() })
        $("#claim-line1").animate({
            left: 0
        }, 1000);

        $("#claim-line2").css({ right: $(window).width() })
        $("#claim-line2").animate({
            left: 0
        }, 1000);

        $("#claim-line3").css({ right: $(window).width() })
        $("#claim-line3").animate({
            left: 0
        }, 1000);
    }



});



