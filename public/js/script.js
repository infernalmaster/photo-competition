$(document).ready(function () {

    initHeaderWithMenu();
    initJurySlider();
    initFileUploader();
    initTakePart();

});

function initHeaderWithMenu(){
    $('body').scrollspy({ target: '.js-main-nav' });

    $(".js-main-nav a").on('click', function(e) {
        e.preventDefault();
        var hash = this.hash;
        // animate
        $('html, body').stop().animate({
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
}

function initJurySlider() {
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
    };
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

    };

    $('.prev').click(previousslide);
    $('.next').click(nextslide);
    $('.ident').eq(1).click(nextslide);
    $('.ident').eq(0).click(previousslide);
}


function initFileUploader() {
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
    };


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
    };

    function uploadProgress(evt) {
        if (evt.lengthComputable) {
            var percentComplete = Math.round(evt.loaded * 100 / evt.total);
            document.getElementById('progressNumber').innerHTML = percentComplete.toString() + '%';
        }
        else {
            document.getElementById('progressNumber').innerHTML = 'unable to compute';
        }
    };

    function uploadComplete(evt) {
        /* This event is raised when the server send back a response */
        alert(evt.target.responseText);
    };

    function uploadFailed(evt) {
        alert("There was an error attempting to upload the file.");
    };

    function uploadCanceled(evt) {
        alert("The upload has been canceled by the user or the browser dropped the connection.");
    };
}


function initTakePart() {
    var $showTakePartContent = $('.js-show-take-part-content'),
        $takePartContent = $('.js-take-part-content'),
        $steps = $('.js-take-part__step'),
        $navItem = $('.js-take-part__nav-item');

    function activateStep(number) {
        $steps.removeClass('active').eq(number).addClass('active');
        $navItem.removeClass('active').eq(number).addClass('active');
        $('html, body').stop().animate({
            scrollTop: $takePartContent.offset().top
        }, 300);
    }

    $showTakePartContent.click(function() {
        activateStep(0);

        if ($takePartContent.hasClass('active')) {
            $showTakePartContent.removeClass('active');
            $takePartContent.removeClass('active');
        } else {
            $showTakePartContent.addClass('active');
            $takePartContent.addClass('active');
        }
    });


    $('.js-agree-with-right').click(function() {
        activateStep(1);
    });

    $('.js-send-profile').click(function() {
        activateStep(2);
    });

    $('.js-send-photos').click(function() {
        activateStep(3);
    });

    $('.js-send-photos').click(function() {
        activateStep(3);
    });

    $('.js-back-from-profile').click(function() {
        activateStep(0);
    });

    $('.js-back-from-photos').click(function() {
        activateStep(1);
    });

    $('.js-close-take-part').click(function(){
        $showTakePartContent.trigger('click');
    });



    $('.js-profile-form').validationEngine('attach',  {promptPosition : "topRight:-150,0", scrollOffset: 220});
}