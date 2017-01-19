// master.js

// removing 'no-js' class
document.body.parentElement.className = 'nothing here'

if (document.location.hash == "#back") {
    $('.site-header').removeClass('site-header-transition')
    $('.site-header').removeClass('vertical-header');
}

$(document).ready(function() {
  // $('.site-header').css("opacity", "0");

  if (document.location.hash == "#back") {
    document.location.hash = "#";
    elements = $('.site-header');
    elements.removeClass('vertical-header');
    elements.css("opacity", "1");

    setTimeout(function() {
      elements.addClass('site-header-transition');
      setTimeout(function (){
        elements.addClass('vertical-header');
      }, 100);
    }, 100);

    $('#main-links').css('opacity', '0');
    setTimeout(function() { 
      $('#main-links').animate({
        opacity: 1,
      }, 200, 'linear');
    }, 300);
  } else {
    $('.site-header').removeClass('site-header-transition');
    $('.site-header').css('opacity', '1');
    $('#main-links').css('opacity', '1');
    setTimeout(function() {
      $('.site-header').addClass('site-header-transition');
    }, 10);
  }

  function transition(to) {
    $('.site-header').removeClass('vertical-header');
    $('#main-links').animate({
      opacity: 0,
    }, 200, 'linear');
    document.location.hash = "#back"
    setTimeout(function () {
      document.location.pathname = to
    }, 520);
  }

  $('.jekyll-link').removeAttr('href')
  $('.jekyll-link').on('click', function () {
    transition('/write/');
  })

  $('.etc-link').removeAttr('href')
  $('.etc-link').on('click', function () {
    transition('/etc/');
  })

  $('.site-header').click(function () {
    // just because the hash is ugly
    return(false);
  });

});
