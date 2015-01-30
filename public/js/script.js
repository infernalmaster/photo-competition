$(document).ready(function () {

    // top menu
    $('body').scrollspy({ target: '.js-main-nav' });
    $(".js-main-nav a").on('click', function(e) {
        e.preventDefault();
        var hash = this.hash;
        // animate
        $('html, body').animate({
            scrollTop: $(hash).offset().top
        }, 300, function(){
            window.location.hash = hash;
        });
    });


    $window = $(window);
    $menu = $('.wrapper_menu');
    $(window).scroll(function () {
        var top = $window.scrollTop();
        //shadow menu
        if (top > 50) {
            $menu.addClass('dropshadow');
        } else {
            $menu.removeClass('dropshadow')
        }
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








    // fileupload
    window.fileSelected = function() {
        var file = document.getElementById('fileToUpload').files[0];
        if (file) {
            var fileSize = 0;
            if (file.size > 1024 * 1024)
                fileSize = (Math.round(file.size * 100 / (1024 * 1024)) / 100).toString() + 'MB';
            else
                fileSize = (Math.round(file.size * 100 / 1024) / 100).toString() + 'KB';

            document.getElementById('fileName').innerHTML = 'Name: ' + file.name;
            document.getElementById('fileSize').innerHTML = 'Size: ' + fileSize;
            document.getElementById('fileType').innerHTML = 'Type: ' + file.type;
        }
    }


    window.uploadFile = function () {
        var fd = new FormData();
        fd.append("image", document.getElementById('fileToUpload').files[0]);
        var xhr = new XMLHttpRequest();
        xhr.upload.addEventListener("progress", uploadProgress, false);
        xhr.addEventListener("load", uploadComplete, false);
        xhr.addEventListener("error", uploadFailed, false);
        xhr.addEventListener("abort", uploadCanceled, false);
        xhr.open("POST", "/upload");
        xhr.send(fd);
    }

    function uploadProgress(evt) {
        if (evt.lengthComputable) {
            var percentComplete = Math.round(evt.loaded * 100 / evt.total);
            document.getElementById('progressNumber').innerHTML = percentComplete.toString() + '%';
        }
        else {
            document.getElementById('progressNumber').innerHTML = 'unable to compute';
        }
    }

    function uploadComplete(evt) {
        /* This event is raised when the server send back a response */
        alert(evt.target.responseText);
    }

    function uploadFailed(evt) {
        alert("There was an error attempting to upload the file.");
    }

    function uploadCanceled(evt) {
        alert("The upload has been canceled by the user or the browser dropped the connection.");
    }
});
