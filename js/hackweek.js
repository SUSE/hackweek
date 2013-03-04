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

    $("#people-link").click(function () {
        $('html, body').animate({
            scrollTop: $("#people").offset().top
        }, 1000);
    })

    $("#agenda-link").click(function () {
        $('html, body').animate({
            scrollTop: $("#agenda").offset().top
        }, 1000);
    })

    $("#projects-link").click(function () {
        $('html, body').animate({
            scrollTop: $("#projects").offset().top
        }, 1000);
    })

    $("#where-link").click(function () {
        $('html, body').animate({
            scrollTop: $("#where").offset().top
        }, 1000);
    })

    $("#terminal-btn").click(function () {
        toggle_terminal()
    })

    $("#terminal-bottom-bar-tab-close").click(function () {
        toggle_terminal()
    })

    $(document).keydown(function(e){
        if (e.keyCode == 0 || e.keyCode == 94 || e.keyCode == 176 || e.keyCode == 160) {
            toggle_terminal()
        }
    })


    function toggle_terminal() {
        if ($('#terminal').is(":visible")) {
            $('#terminal').slideUp('fast');
            $('#wterm').find('div:last form input').blur()
        } else {
            $('#terminal').slideDown('fast');
            $('#wterm').find('div:last form input').focus()
        }

    }

    $(window).scroll(function () {

        /* hide - unhide navigation, arrow, terminal button on first page */
        if (!$('#navigation').is(":visible") && $(window).scrollTop() >= $('#what-is').height()/1.5) {
            $('#navigation').fadeIn()
            $('#terminal-btn').fadeIn()
            $('#arrow-start').fadeOut()

        }
        if ($('#navigation').is(":visible") && $(window).scrollTop() < $('#what-is').height()/1.5) {
            $('#navigation').fadeOut()
            $('#terminal-btn').fadeOut()
            $('#arrow-start').fadeIn()
        }

        /* start page text scroll animation */
        if ($(window).scrollTop() <= $('#start').height()) {
            var percent_scrolled_out = $(window).scrollTop() / $('#start').height()
            var lines = ["1", "2", "3", "4"]
            lines.forEach(function (entry) {
                var element = $("#claim-line" + entry)
                element.css({ top: $(window).scrollTop() + percent_scrolled_out * ($('#start').height() / 2 - element.position().top),
                    'opacity': 1 - percent_scrolled_out });
            });
        }

        /* people page text scroll animation */
        if ($(window).scrollTop() > $('#people').position().top - $('#people').height() &&
            $(window).scrollTop() < $('#people').position().top + 2 * $('#people').height()) {
            var percent_scrolled_out = Math.abs(($(window).scrollTop() - $('#people').position().top) / $('#people').height())
            $('.project-instructions').css({'opacity': 1 - percent_scrolled_out * 3})
        }

        /* where page text scroll animation */
        if ($(window).scrollTop() > $('#where').position().top - $('#where').height()) {
            var percent_scrolled_out = Math.abs(($(window).scrollTop() - $('#where').position().top) / $('#where').height())
            $('#where-title').css({'opacity': 1 - percent_scrolled_out/2,
                right: percent_scrolled_out * -500})
        }

        /* set active page in navigation menu */
        if ($(window).scrollTop() > $('#where').position().top - $('#where').height() / 2) {
            $('#navigation li').removeClass('active')
            $('#where-link').addClass('active')
        } else if ($(window).scrollTop() > $('#people').position().top - $('#people').height() / 2) {
            $('#navigation li').removeClass('active')
            $('#people-link').addClass('active')
        } else if ($(window).scrollTop() > $('#projects').position().top - $('#projects').height() / 2) {
            $('#navigation li').removeClass('active')
            $('#projects-link').addClass('active')
        } else if ($(window).scrollTop() > $('#agenda').position().top - $('#agenda').height() / 2) {
            $('#navigation li').removeClass('active')
            $('#agenda-link').addClass('active')
        } else if ($(window).scrollTop() > $('#what-is-link').position().top - $('#what-is-link').height() / 2) {
            $('#navigation li').removeClass('active')
            $('#what-is-link').addClass('active')
        }

        /* invert navigation color */
        $('#navigation li').each(function( index ) {
            $(this).removeClass('invert')
            if (($(this).position().top + $(this).height() > $("#people").position().top - $(window).scrollTop()) &&
                ($(this).position().top + $(this).height() < $("#people").position().top - $(window).scrollTop() + $('#people').height())) {
               $(this).addClass('invert')
            }
            if (($(this).position().top + $(this).height() > $("#what-is").position().top - $(window).scrollTop()) &&
                ($(this).position().top + $(this).height() < $("#what-is").position().top - $(window).scrollTop() + $('#what-is').height())) {
                $(this).addClass('invert')
            }
        });


    })


    /* start page text initial animation */
    if ($(window).scrollTop() == 0) {
        $("#claim-line1").css({ top: -600 })
        $("#claim-line1").animate({
            top: 0
        }, 800);

        $("#claim-line2").css({ left: $(window).width() })
        $("#claim-line2").animate({
            left: 0, top: 0
        }, 800);

        $("#claim-line3").css({ right: $(window).width() })
        $("#claim-line3").animate({
            left: 0, top: 0
        }, 800);

        $("#claim-line4").css({ bottom: -600 })
        $("#claim-line4").animate({
            top: 0
        }, 800);
    }



  // Setup terminal
  $('#wterm').wterm({
      WELCOME_MESSAGE: "<span class='welcome-message'>Welcome to Hackweek 9! Have a lot of fun...<span>",
      PS1:             "geeko@hackweek:~ >",
      NOT_FOUND:       "Sorry me and my chameleon friends have never heard about CMD before :-(",
      WIDTH:           "80%",
      HEIGHT:          "500px"
  });
});



