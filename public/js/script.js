$(document).ready(function () {

    var top = $(window).scrollTop();
    mi_start = $('.mi_start');
    mi_calendar = $('.mi_calendar');
    mi_awards = $('.mi_awards');
    mi_partners = $('.mi_partners');
    mi_jury = $('.mi_jury');

    //main menu scrolling
    //hilighting
    $('nav li').each(function () {
        $(this).click(function () {
            $(this).addClass('active').siblings().removeClass('active');
        });

    });
    //scrolling
    mi_start.click(function () {
        $(document).scrollTop(0);
    });
    mi_calendar.click(function () {
        $(document).scrollTop($('.calendar').position().top - 119);
    });
    mi_awards.click(function () {
        $(document).scrollTop($('.awards').position().top - 119);
    });
    mi_partners.click(function () {
        $(document).scrollTop($('.sponsors').position().top - 119);
    });

    mi_jury.click(function () {
        $(document).scrollTop($('.jury').position().top - 119);

    });

    $('.prev').hide();

    var nextslide = function () {
        $('.next').hide('0', function () {
            $('.prev').show('0', function () {
            });
        });
        if (!$('.slider').is(':animated')) {
            $('.slider').animate(
                {left: -600}, 400);
            $('.current').removeClass('current');
            $('.ident').eq(1).addClass('current');
        }
    }

    var previousslide = function () {
        $('.prev').hide('0', function () {
            $('.next').show('0', function () {
            });

        });
        if (!$('.slider').is(':animated')) {
            $('.slider').animate(
                {left: 0}, 400);
            $('.current').removeClass('current');
            $('.ident').eq(0).addClass('current');
        }

    }

    $('.prev').click(previousslide);

    $('.next').click(nextslide);

    $('.ident').eq(1).click(nextslide);

    $('.ident').eq(0).click(previousslide);
//close dd
    function close_dd() {
        $('#dd_takepart_content').slideUp(200);
        $('#dd_button').css('background', '#8f7726');
        $('#dd_takepart_content').children().css('display', 'none');
        $('.steps').find('.active').removeClass('active');
        $('.step_terms').addClass('active');
    }

//
    $('#dd_button').click(
        function () {
            if (!$('#dd_takepart_content').is(':visible')) {
                $('.terms').css('display', 'block');
                $('.steps').show('0');
                $('#dd_button').css('background', '#5a4b18');
                $('#dd_takepart_content').slideDown(200);

            }
            else {
                close_dd();
            }
        }
    );

    $('.close').click(function (event) {
        close_dd();
        $('input:text').val('');//clear input
    });


//fwd&bck btns
    $('.forward').click(function (event) {


            $(this).parent().css('display', 'none');
            $(this).parent().next().css('display', 'block');
            $('.steps').find('.active').removeClass('active').next().next().addClass('active');
            $(document).scrollTop($('#dd_button').position().top);


        }
    );
    $('.back').click(function (event) {
        $(this).parent().css('display', 'none');
        $(this).parent().prev().css('display', 'block');
        $('.steps').find('.active').removeClass('active').prev().prev().addClass('active');
        $(document).scrollTop($('#dd_button').position().top);

    });

});


$(window).scroll(function () {
    var top = $(window).scrollTop();
    mi_start = $('.mi_start');
    mi_calendar = $('.mi_calendar');
    mi_awards = $('.mi_awards');
    mi_partners = $('.mi_partners');
    mi_jury = $('.mi_jury');

    //shadow menu
    if (top > 50) {
        $('.wrapper_menu').addClass('dropshadow');
    }

    else {
        $('.wrapper_menu').removeClass('dropshadow')
    }
    ;
    //hlight on scroll
    if (top < $('.calendar').position().top - 120) {
        mi_start.siblings().removeClass('active');
        mi_start.addClass('active');
    } else if (top > $('.calendar').position().top + 10 && top < $('.awards').position().top - 120) {
        mi_calendar.siblings().removeClass('active');
        mi_calendar.addClass('active');
    } else if (top > $('.awards').position().top - 10 && top < $('.sponsors').position().top - 120) {
        mi_awards.siblings().removeClass('active');
        mi_awards.addClass('active');
    } else if (top > $('.sponsors').position().top - 10 && top < $('.partners').position().top - 120) {
        mi_partners.siblings().removeClass('active');
        mi_partners.addClass('active');
    } else if (top > $('.partners').position().top + 400) {
        mi_jury.siblings().removeClass('active');
        mi_jury.addClass('active');
    }
    //
});
