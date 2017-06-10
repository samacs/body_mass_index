document.addEventListener('turbolinks:load', function () {
  /**
   * Bootstrap default screen sizes.
   **/
  var screen_breakpoints = {
    screen_xs : 480,
    screen_sm: 768,
    screen_md: 992,
    screen_lg: 1200
  };

  var screen_size = {
    screen_xs_min: screen_breakpoints.screen_xs,
    screen_sm_min: screen_breakpoints.screen_sm,
    screen_md_min: screen_breakpoints.screen_md,
    screen_lg_min: screen_breakpoints.screen_lg,

    screen_xs_max: (screen_breakpoints.screen_sm - 1), //(screen_sm_min - 1),
    screen_sm_max: (screen_breakpoints.screen_md - 1), //(screen_md_min - 1),
    screen_md_max: (screen_breakpoints.screen_lg - 1)  //(screen_lg_min - 1),
  };

  var screen_devices = {
    screen_phone: screen_size.screen_xs_min,
    screen_tablet: screen_size.screen_sm_min,
    screen_desktop: screen_size.screen_md_min,
    screen_lg_desktop: screen_size.screen_lg_min,

    grid_float_breakpoint: screen_size.screen_sm_min,
    grid_float_breakpoint_max: (screen_size.screen_sm_min - 1) //(grid_float_breakpoint - 1)
  };

  // trim polyfill : https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/Trim
  if (!String.prototype.trim) {
    (function() {
      // Make sure we trim BOM and NBSP
      var rtrim = /^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g;
      String.prototype.trim = function() {
        return this.replace(rtrim, '');
      };
    })();
  }

  /**
   * SCREENSHOTS CAROUSEL
   * ( ! ) This section could be done in html markup directly
   * since we are just generating HTML markup to make the slider.
   * You could just take this script off and write your own markup, in the following way
   * <a href="path/to/your/image"><img src="path/to/your/image"/></a>
   * write as many <a> tags as images you would like to show
   **/
  function screenshotsSlider(selector, cssClass, options) {
    if (typeof cssClass == "object") {
      options = cssClass;
      cssClass = null;
    }

    var $screenshots = $(selector);
    if (cssClass) { $screenshots.addClass(cssClass); }
    var count = $screenshots.data("slides-count");
    var slides = [];

    for (var i = 1; i <= count; i++) {
      var src = "img/screenshots/" + i + ".jpg";

      slides.push(
        $("<a/>", {
          href: src,
          class: "mockup",
          html: $("<img/>", {
            src: src
          })
        })
      );
    }

    // Append the markup just generated and make it carousel
    $screenshots.append(slides);

    $('.mockup', $screenshots).magnificPopup({
      type: 'image',
      preload: [1, 2],
      gallery: {
        enabled: true
      }
    });

    $screenshots.owlCarousel($.extend(options || {}, {
      loop: true,
      autoplay: true,
      autoplayTimeout: 3000,
      autoplayHoverPause: true
    }));
  }

  function resizeWindow() {
    var isXS = window.innerWidth <= screen_devices.grid_float_breakpoint_max;

    // set size of page heading
    //$(".landing-heading").css({"min-height": window.innerHeight});
  }

  /**
   * Particleground integration
   **/
  if (document.getElementById("particles")) {
    $('.particles').particleground({
      minSpeedX:.6,
      minSpeedY:.6,
      dotColor:"#ffffff",
      lineColor:"#ffffff",
      density:6e3,
      particleRadius:2,
      parallaxMultiplier:5.2,
      proximity:0
    });
  }

  /**
   * PROCESS SLIDER
   **/
  $(".process .process-inner").flexslider({
    animation: "slide",
    manualControls: ".process-nav li",
    animationLoop: false,
    useCSS: false,
    slideshowSpeed: 4000,
    pauseOnHover: true,
    directionNav: false,

    before: function(slider) {
      var cssClass = "loaded";
      var $target = slider.controlNav.filter('li:nth(' + slider.animatingTo + ')');

      $target.prevAll().addClass(cssClass);
      $target.nextAll().removeClass(cssClass);
    }
  });

  /**
   * SECTION FULL WIDTH VIDEO
   **/
  $('.video-fullwidth').videoplayer('video/under', {
    play: "fa-play",
    pause: "fa-pause"
  });

  /**
   * WORKING WITH INPUTS
   **/
  $('.control .form-control').each(function() {
    var $input = $(this);
    var $parent = $input.parent();

    if (this.value.trim() !== '') {
      $parent.addClass('control-filled');
    }

    $input.on('focus', function () {
      $parent.addClass('control-filled');
    }).on('blur', function (e) {
      if ($input.val().trim() === '' ) {
        $parent.removeClass('control-filled');
      }
    });
  });

  /**
   * COUNTERS
   **/
  $('.counter .value').counterUp({
    delay: 200,
    time: 1000
  });

  /**
   * TYPE WRITER ELEMENTS
   **/
  $(".typed-element").typed({
    loop: true,
    typeSpeed: 100,
    strings: ["creative", "smart", "elegant", "modern"]
  });

  /**
   * ANIMATION BAR
   **/
  (function () {
    $(".progress-bars").animateBar({
      orientation: "horizontal",
      step: 100,
      duration: 1000,
      elements: [
        { label: "Implementation", value: 89 },
        { label: "Design", value: 97 },
        { label: "Branding", value: 81 },
        { label: "Beauty", value: 99 },
        { label: "Responsiveness", value: 99 }
      ]
    });
  })();

  /**
   * SUBMITTING THE FORMS
   **/
  (function () {
    $("form.remote").each(function() {
      var $form = $(this);
      var options = {
        errorPlacement: function(error, element) {
          var $parent = element.parent();

          if ($parent.hasClass("input-group")) {
            error.insertAfter($parent);
          } else if ($parent.hasClass("control")) {
            error.insertAfter(element.next('.control-label'));
          } else {
            error.insertAfter(element);
          }
        }
      };

      if ($form.data("validate-on") == "submit") {
        $.extend(options, {
          onfocusout: false,
          onkeyup: false
        });
      }

      // call to validate plugin
      $form.validate(options);
    });

    $("form.remote").submit(function(evt) {
      evt.preventDefault();
      var $form = $(this);

      if (!$form.valid()) {
        return false;
      }

      var $submit = $("button[type=submit]", this).button('loading');
      var $message = $form.next(".response-message");

      function doAjax(url, data, config) {
        var settings = $.extend(true, {}, config, {
          url: url,
          type: 'POST',
          data: data,
          dataType: 'json'
        });

        $.ajax(settings)
         .done(function(data) {
           if (data.result) {
             $form.trigger("form.submitted", [this, data]);

             $("input, textarea", $form).removeClass("error");
             $("p", $message).html(data.message);

             $form.addClass('submitted');
             $form[0].reset();
           } else {
             if (data.errors) {
               $.each(data.errors, function(i, v) {
                 var $input = $("[name$='[" + i + "]']", $form).addClass('error');
                 $input
                   .tooltip({title: v, placement: 'bottom', trigger: 'manual'}).tooltip('show')
                   .on('focus', function() { $(this).tooltip('destroy'); });
               });
             }
           }
         }).fail(function() {
           $("p", $message).html($("<span class='block'>Something went wrong.</span>"));
         }).always(function() {
           $submit.button('reset');
         });
      }

      function submitAjax($form) {
        doAjax(
          $form.attr('action'),
          $form.serializeArray()
        );
      }

      submitAjax($form);

      return false;
    });
  })();

  /**
   * CREATING THE LOGO BRANDS
   */
  (function(){
    var $brandsWrapper = $(".brands .slides-wrapper").addClass("flexslider");
    var clientCount = $brandsWrapper.data("elements");

    var brandsSlides = [];
    var src = "img/section/brands/";

    var $slides = $("<ul>", {
      class: "slides"
    });

    for (var i = 1; i <= clientCount; i++) {
      brandsSlides.push(
        $("<li/>", {
          html: $("<figure/>", {
            class: "mockup",
            html: $("<img/>", {
              src: src + i + ".png"
            })
          })
        })
      );
    }

    $brandsWrapper.append($slides);
    $slides.append(brandsSlides);

    $brandsWrapper.flexslider({
      animation: "slide",
      controlNav: false,
      //directionNav: false,
      itemWidth: 120,
      itemMargin: 75
    });
  })();

  /**
   * TESTIMONIALS SLIDER
   **/
  (function() {
    var $testimonialsWrapper = $('.testimonials .slides-wrapper');
    var testimonialsNav = [];
    var src = "img/section/users/";

    $('.slides li', $testimonialsWrapper).each(function(i) {
      testimonialsNav.push(
        $("<li/>", {
          html: $("<figure/>", {
            class: "mockup photo",
            html: $("<img/>", {
              src: src + (i + 1) + ".jpg"
            })
          })
        })
      );
    });

    //thumbnails navigation
    var $thumbnails = $(".testimonials-thumbnails").append($('<ul>', {
      class: 'slides testimonials-control-nav',
      html: testimonialsNav
    })).flexslider({
      animation: "slide",
      controlNav: false,
      slideshow: false,
      itemWidth: 60,
      itemMargin: 8,
      asNavFor: $testimonialsWrapper
    });

    //testimonials
    $testimonialsWrapper.flexslider({
      animation: "slide",
      controlNav: false,
      //animationLoop: false,
      slideshow: false,
      sync: $thumbnails
    });
  })();

  /**
   * POPUPS
   **/
  (function() {
    $('.popup-video').magnificPopup({
      disableOn: screen_devices.grid_float_breakpoint,
      type: 'iframe',
      mainClass: 'mfp-fade',
      removalDelay: 160,
      preloader: false,
      fixedContentPos: false
    });

    $('.modal-popup').magnificPopup({
      type: 'inline',
      removalDelay: 500,
      preloader: false,
      midClick: true,
      callbacks: {
        beforeOpen: function() {
          this.st.mainClass = this.st.el.attr('data-effect');
        }
      }
    });

    $(document).on('click', '.modal-popup-dismiss', function (e) {
      e.preventDefault();
      $.magnificPopup.close();
    });
  })();

  /**
   * CALL ALL FUNCTIONS
   **/
  screenshotsSlider(".screenshots.carousel .container-fluid .slider", "owl-carousel owl-theme", {
    margin: 10,
    responsive: {
      0: {
        items: 1
      },
      480: {
        items: 2
      },
      768: {
        items: 4
      },
      992: {
        items: 5
      },
      1200: {
        items: 7
      }
    }
  });

  resizeWindow();

  /**
   * DOM EVENTS
   **/
  $(window).resize(function() {
    resizeWindow();
  });

  /**
   * ANIMATE ELEMENTS WHEN SCROLLING
   **/
  if(Modernizr.mq('only all and (min-width: ' + screen_devices.grid_float_breakpoint + 'px)')) {
    var getAnimationData = function(e, attr, def) {
      var value = e.data("animation-" + attr);
      if (typeof value == "undefined" || value == false) {
        value = def;
      }

      return value;
    };

    $('[data-animation]').each(function() {
      var $this = $(this);
      var animation = $this.data("animation");
      var duration = getAnimationData($this, "duration", 1);
      var delay = getAnimationData($this, "delay", 0);

      $this.css({
        "animation-duration": duration + "s",
        "animation-delay": delay + "s"
      });

      $this.waypoint(function(direction) {
        //console.log('direction', direction, this);
        $this.addClass(animation).css({ "visibility": "visible" });
        this.destroy();
      },{
        //triggerOnce: true,
        offset: '90%'
      });
    });
  }
});
