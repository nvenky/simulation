$('.homepage').scroll ->
  if $(".navbar").offset().top > 50
    $(".navbar-fixed-top").addClass("top-nav-collapse")
  else
    $(".navbar-fixed-top").removeClass("top-nav-collapse")
  

$('.homepage').ready ->
  $('a.page-scroll').bind 'click', (event)->
    $anchor = $(this)
    $('html, body').stop().animate({
      scrollTop: $($anchor.attr('href')).offset().top
    }, 1500, 'easeInOutExpo')
    event.preventDefault()

$('.homepage .navbar-collapse ul li a').click ->
  $('.homepage .navbar-toggle:visible').click()
