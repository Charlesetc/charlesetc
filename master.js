// Generated by CoffeeScript 1.7.1
(function() {
  $(function() {
    var hide_section, show_section;
    hide_section = function(section) {
      return $(section).animate({
        opacity: 0
      }, 200, function() {
        return $(section).css('display', 'none');
      });
    };
    show_section = function(section) {
      $(section).css('display', 'block');
      return $(section).animate({
        opacity: 1
      }, 200);
    };
    $('#photo1, #photo2').click(function() {
      return $('.charles').click();
    });
    $('.charles').click(function() {
      if (!$(this).hasClass('disabled')) {
        $(this).addClass('disabled');
        if ($(this).hasClass('clicked')) {
          $(this).removeClass('clicked');
          hide_section("#photo");
          $('.charles').animate({
            top: 0
          }, 500);
          return $('.pipin, .chamberlain').animate({
            left: 0
          }, 500, function() {
            $('.charles').removeClass('disabled');
            return $('.charles span').text('Etc');
          });
        } else {
          $(this).addClass('clicked');
          $('.pipin, .chamberlain').animate({
            left: -$(window).width() - 750
          }, 500);
          return $('.charles').animate({
            top: -1 * $(window).height() * 0.10
          }, 500, function() {
            show_section('#photo');
            $('.charles').removeClass('disabled');
            return $('.charles span').text('Home');
          });
        }
      }
    });
    $('.pipin').click(function() {
      if (!$(this).hasClass('disabled')) {
        $(this).addClass('disabled');
        if ($(this).hasClass('clicked')) {
          $(this).removeClass('clicked');
          hide_section('#contact');
          $('.charles, .chamberlain').animate({
            left: 0,
            opacity: 1
          }, 500);
          return $('.pipin').animate({
            top: 0
          }, 500, function() {
            $('.pipin span').text('Contact');
            return $('.pipin').removeClass('disabled');
          });
        } else {
          $(this).addClass('clicked');
          $('.charles, .chamberlain').animate({
            left: -2000,
            opacity: 0
          }, 500);
          return $('.pipin').animate({
            top: -1 * $(window).height() * 0.25
          }, 500, function() {
            show_section('#contact');
            $('.pipin span').text('Home');
            return $('.pipin').removeClass('disabled');
          });
        }
      }
    });
    return $('.chamberlain').click(function() {
      if (!$(this).hasClass('disabled')) {
        $(this).addClass('disabled');
        if ($(this).hasClass('clicked')) {
          $(this).removeClass('clicked');
          hide_section("#portfolio");
          $('.charles, .pipin').animate({
            left: 0,
            opacity: 1
          }, 500);
          return $('.chamberlain').animate({
            top: 0
          }, 500, function() {
            $('.chamberlain span').text('Portfolio');
            return $('.chamberlain').removeClass('disabled');
          });
        } else {
          $(this).addClass('clicked');
          $('.charles, .pipin').animate({
            left: -2000,
            opacity: 0
          }, 500);
          return $('.chamberlain').animate({
            top: -1 * $(window).height() * 0.40
          }, 500, function() {
            show_section('#portfolio');
            $('.chamberlain span').text('Home');
            return $('.chamberlain').removeClass('disabled');
          });
        }
      }
    });
  });

}).call(this);
