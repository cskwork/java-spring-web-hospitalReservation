$(window).scroll(function() {
    if ($(document).scrollTop() > 930) {
        $('.navbar').addClass('navbar-shrink');
    }
    else {
        $('.navbar').removeClass('navbar-shrink');
    }
});

/*$(function() {
  $('a[href*=#]:not([href=#])').click(function() {
    if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
      var target = $(this.hash);
      target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
      if (target.length) {
        $('html,body').animate({
          scrollTop: target.offset().top
        }, 1000);
        return false;
      }
    }
  });
});*/

// Owl carousel
$('.owl-partners').owlCarousel({
    loop:true,
    margin:10,
    nav:false,
    autoplay:true,
    autoplayTimeout:3000,
    autoplayHoverPause:true,
    responsive:{
        0:{
            items:1
        },
        600:{
            items:3
        },
        1000:{
            items:5
        }
    }
})

// Owl carousel
$('.owl-portfolio').owlCarousel({
    loop:true,
    margin:10,
    nav:true,
    navText: [
          "<i class='fa fa-angle-left'></i>",
          "<i class='fa fa-angle-right'></i>"
          ],
    dots:false,
    autoplay:true,
    autoplayTimeout:5000,
    autoplayHoverPause:true,
    responsive:{
        0:{
            items:1
        },
        600:{
            items:1
        },
        1000:{
            items:1
        }
    }
})

// Owl carousel
$('.owl-slider').owlCarousel({
    loop:true,
    margin:0,
    nav:true,
    navText: [
          "<i class='fa fa-angle-left'></i>",
          "<i class='fa fa-angle-right'></i>"
          ],
    dots:false,
    autoplay:true,
    smartSpeed:850,
    autoplayTimeout:6000,
    autoplayHoverPause:true,
    responsive:{
        0:{
            items:1
        },
        600:{
            items:1
        },
        1000:{
            items:1
        }
    }
})

  // hide #back-top first
  $("#back-top").hide();

  // fade in #back-top

  $(window).scroll(function () {
  	if ($(this).scrollTop() > 300) {
  		$('#back-top').fadeIn();
  	} else {
  		$('#back-top').fadeOut();
  	}
  });

  // scroll body to 0px on click
  $('#back-top a').on("click", function(){
  	$('body,html').animate({
  		scrollTop: 0
  	}, 800);
  	return false;
  });

// Closes the Responsive Menu on Menu Item Click
$('.navbar-collapse ul li a').click(function() {
    $('.navbar-toggle:visible').click();
});