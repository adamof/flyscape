"use strict";
jQuery(document).ready(function ($) {
  gmaps_initialize();
  var links = $('nav').find('a'),
  slide = $('article'),
  currentStep = 0,
  scrolling = false,
  // Constants
  navHeight = 40,
  articleHeight = 579;
  // Set up step height
  $('article').css({'margin-bottom': window.innerHeight - navHeight - articleHeight});
  window.onresize=function(){
    $('article').css({'margin-bottom': window.innerHeight - navHeight - articleHeight})
  };

  // Navigation
  $('header').waypoint(function (direction) {
    $('nav').toggleClass('fixedPosition');
  }, {
    offset: function() { return -$(this).height(); }
  });

  slide.waypoint(function (direction) {
    var step = $(this).attr('data-step');
    if (direction === 'down') {
      $('nav a[data-step="' + step + '"]').addClass('active').prev().removeClass('active');
    }
    else {
      $('nav a[data-step="' + step + '"]').addClass('active').next().removeClass('active');
      if (currentStep == 1){currentStep = 0}
    }
  });

  function scrollTo(step) {
    $('html,body').animate({
      scrollTop: $('article[data-step="' + step + '"]').offset().top - navHeight
    }, 1000, function(){scrolling = false;});
  }

  links.click(function (e) {
    currentStep = parseInt($(this).attr('data-step'));
    scrollTo( currentStep );
    return false;
  });

  $(window).mousewheel(function(event, delta, deltaX, deltaY) {
      if (deltaY == -1 && !scrolling){
        if (currentStep < 3){
          scrolling = true;
          currentStep += 1;
          scrollTo(currentStep);
        } else {
          scrolling = false;
        }
      } else if (deltaY == 1 && !scrolling) {
        if (currentStep > 1){
          scrolling = true;
          currentStep -= 1;
          scrollTo(currentStep);
        } else {
          scrolling = false;
        }
      }
  });

  // Step 1
  $('input[name=start-location]').click(function(event) {
    getLocation();
  });

  function setStart (position) {
    console.log(position);
  }
  function handleError(argument) {

  }


  // Step 3 - Calendars
  var template = $("#clndr-template").html();
  function create_calendar(jq_selector) {
    var result = $(jq_selector).clndr({
      _name: 'kur',
      template: template,
      weekOffset: 1,
      adjacentDaysChangeMonth: true,
      clickEvents: {
        click: function(target){
          toggle_calendar(this, jq_selector, target.date._i);
        }
      }
    });
    result.calendarContainer.addClass("calendar-hidden");
    return result
  }
  function toggle_calendar(calendar, name, date) {
    calendar.calendarContainer.addClass("calendar-hidden");
    if (name == '.clndr-holder-start'){
      $('input[name=clndr-start]').val(date);
    } else if (name == '.clndr-holder-end'){
      $('input[name=clndr-end]').val(date);
    }
  }

  var calendar_start = create_calendar('.clndr-holder-start');
  var calendar_end = create_calendar('.clndr-holder-end');

  $('input[name=clndr-start]').click(function(event) {
    calendar_start.calendarContainer.removeClass("calendar-hidden");
  });
  $('input[name=clndr-end]').click(function(event) {
    calendar_end.calendarContainer.removeClass("calendar-hidden");
  });


});
