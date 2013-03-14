$(function () {

    $("#start-link").click(function () {
        $('html, body').animate({
            scrollTop: $("#start").offset().top
        }, 1000);
    })

    $("#what-is-link, #arrow-start, #what-is-start, #hackweek9").click(function () {
        $('html, body').animate({
            scrollTop: $("#what-is").offset().top
        }, 1000);
    })

    $("#people-link").click(function () {
        $('html, body').animate({
            scrollTop: $("#people").offset().top
        }, 1000);
    })

    $("#agenda-link, #agenda-start").click(function () {
        $('html, body').animate({
            scrollTop: $("#agenda").offset().top
        }, 1000);
    })

    $("#projects-link, #projects-start").click(function () {
        $('html, body').animate({
            scrollTop: $("#projects").offset().top
        }, 1000);
    })

    $("#where-link, #where-start").click(function () {
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
        if (e.keyCode == 0 || e.keyCode == 94 || e.keyCode == 54 || e.keyCode == 176 || e.keyCode == 160) {
            toggle_terminal()
        }
    })

    /* agenda */

    $("#monday .agenda-item .day-number").on('mouseover click', function(event) {
        event.stopPropagation()
        slidein_agenda_day($('#monday-content'), 0 * 200)
    })
    $("#tuesday .agenda-item .day-number").on('mouseover click', function(event) {
        event.stopPropagation()
        slidein_agenda_day($('#tuesday-content'), 1 * 200)
    })
    $("#wednesday .agenda-item .day-number").on('mouseover click', function(event) {
        event.stopPropagation()
        slidein_agenda_day($('#wednesday-content'), 2 * 200)
    })
    $("#thursday .agenda-item .day-number").on('mouseover click', function(event) {
        event.stopPropagation()
        slidein_agenda_day($('#thursday-content'), 3 * 200)
    })
    $("#friday .agenda-item .day-number").on('mouseover click', function(event) {
        event.stopPropagation()
        slidein_agenda_day($('#friday-content'), 4 * 200)
    })


    function set_agenda_location(loc) {
        var converter = new Showdown.converter();
        $('#monday-content .agenda-details').html(converter.makeHtml(agenda_content[loc].monday))
        $('#tuesday-content .agenda-details').html(converter.makeHtml(agenda_content[loc].tuesday))
        $('#wednesday-content .agenda-details').html(converter.makeHtml(agenda_content[loc].wednesday))
        $('#thursday-content .agenda-details').html(converter.makeHtml(agenda_content[loc].thursday))
        $('#friday-content .agenda-details').html(converter.makeHtml(agenda_content[loc].friday))
        $("#agenda-offices span").removeClass('current')
        $("#agenda-" + loc + "-link").addClass('current')
        $.cookie("agenda-location", loc)
        $('.agenda-details').stop().css('opacity', '0')
        $('.agenda-details').stop().animate({
            'opacity': 1
        }, 800);
    }


    $("#agenda").click(function () {
        $(".agenda-day-content").stop().animate({
            'width': '0px', 'opacity': 0
        }, 800);
    })

    $("#agenda-de-link").click(function (event) {
        event.stopPropagation()
        set_agenda_location('de')
    })
    $("#agenda-us-link").click(function (event) {
        event.stopPropagation()
        set_agenda_location('us')
    })
    $("#agenda-cz-link").click(function (event) {
        event.stopPropagation()
        set_agenda_location('cz')
    })
    $("#agenda-chn-link").click(function (event) {
        event.stopPropagation()
        set_agenda_location('chn')
    })

    if ($.cookie("agenda-location")) {
        set_agenda_location($.cookie("agenda-location"))
    } else {
        set_agenda_location('de')
    }

    /* auto open current agenda day */
    var today = new Date();
    if( today.getMonth()+1 == 4 && today.getYear() == 113) {
        if (today.getDate() == 8) slidein_agenda_day($('#monday-content'))
        if (today.getDate() == 9) slidein_agenda_day($('#tuesday-content'))
        if (today.getDate() == 10) slidein_agenda_day($('#wednesday-content'))
        if (today.getDate() == 11) slidein_agenda_day($('#thursday-content'))
        if (today.getDate() == 12) slidein_agenda_day($('#friday-content'))
    }


    function slidein_agenda_day(element, offset) {
        if (element.css('width') == "0px") {
            $("#agenda-content").stop().animate({
                'left': (0 - offset) + 'px'
            }, 800);
            $(".agenda-day-content").stop().animate({
                'width': '0px', 'opacity': 0
            }, 800);
            element.css({ width: 0, 'opacity': 0 })
                .show()
                .stop().animate({
                    'width': '400px', 'opacity': 1, 'margin-left': '30px'
                }, 800);
        }
    }


    /* where page actions */
    $(".location").on('mouseover click', function(event) {
        $(".location-zoom").hide("scale")
        $("#" + $(this).attr('id') + "-zoom").show("scale")
    })

    $(".location-zoom").on('mouseleave', function(event) {
        $(this).hide("scale")
    })



    window.toggle_terminal = function() {
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
            //$('#terminal-btn').fadeOut()
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
                right: (percent_scrolled_out * -500) - 40})
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
        $('#navigation li').each(function (index) {
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

        /* invert terminal link color */
        $('#terminal-btn').removeClass('invert')
        if (($('#terminal-btn').position().top + $('#terminal-btn').height()/2 > $("#people").position().top - $(window).scrollTop()) &&
                ($('#terminal-btn').position().top + $('#terminal-btn').height()/2 < $("#people").position().top - $(window).scrollTop() + $('#people').height())) {
            $('#terminal-btn').addClass('invert')
        }
        if (($('#terminal-btn').position().top + $('#terminal-btn').height()/2 > $("#what-is").position().top - $(window).scrollTop()) &&
            ($('#terminal-btn').position().top + $('#terminal-btn').height()/2 < $("#what-is").position().top - $(window).scrollTop() + $('#what-is').height())) {
            $('#terminal-btn').addClass('invert')
        }
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
      WELCOME_MESSAGE: "<span class='welcome-message'>Welcome to Hack Week 9! Have a lot of fun...<span><br><span class='welcome-message'>See 'help' for more information on a specific command.<span>",
      PS1:             "geeko@hackweek:~ >",
      NOT_FOUND:       "Sorry me and my chameleon friends have never heard about CMD before :-(",
      WIDTH:           "80%",
      HEIGHT:          "500px"
  });
});



