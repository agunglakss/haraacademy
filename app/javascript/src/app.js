(function (window, document, $, undefined) {
    'use strict';

    var eduJs = {
        i: function (e) {
            eduJs.d();
            eduJs.methods();
        },
        d: function (e) {
            this._window = $(window),
                this._document = $(document),
                this._body = $('body'),
                this._html = $('html')
        },

        methods: function (e) {
            eduJs.bgMarque();
            eduJs.stickyHeaderMenu();
            eduJs.magnigyPopup();
            eduJs.qtyBtn();
            // eduJs.popupMobileMenu();
            eduJs.searchPopup();
            eduJs.widgetToggle();
            eduJs.contactForm();
        },

        bgMarque: function () {
            $('.background-marque').each(function () {
                var t = 0;
                var i = 1;
                var $this = $(this);
                setInterval(function () {
                    t += i;
                    $this.css('background-position-x', -t + "px");
                }, 10);
            });
        },

        ToolTip: function () {
            Tipped.create(
                '.inline', 
                'options!', 
                { 
                    skin: "light",
                    position: 'right',
                    // hideOn: false
                }
            );
        },

        stickyHeaderMenu: function() {

            $(window).on('scroll', function() {
                // Sticky Class Add
                if ($('body').hasClass('sticky-header')) {
                    var stickyPlaceHolder = $('#edu-sticky-placeholder'),
                        menu = $('.header-mainmenu'),
                        menuH = menu.outerHeight(),
                        topHeaderH = $('.header-top-bar').outerHeight() || 0,
                        targrtScroll = topHeaderH + 200;
                    if ($(window).scrollTop() > targrtScroll) {
                        menu.addClass('edu-sticky');
                        stickyPlaceHolder.height(menuH);
                    } else {
                        menu.removeClass('edu-sticky');
                        stickyPlaceHolder.height(0);
                    }
                }
            });
        },

        magnigyPopup: function () {
            $(document).on('ready', function () {
                $('.video-popup-activation').magnificPopup({
                    type: 'iframe'
                });
            });
        },

        widgetToggle: function () {
            $('.widget-toggle').on('click', function() {
                var $this = $(this),
                    $parents = $this.parents('.edu-course-widget');

                if (!$parents.hasClass('collapsed')) {
                    $parents.addClass('collapsed');
                    $this.next('.content').slideUp(400);
                }else {
                    $parents.removeClass('collapsed');
                    $this.next('.content').slideDown(400);
                }
            });

            $(".toggle-btn").on('click', function(e) {

                var target = $(this).parent().siblings(".toggle-open");
                var target2 = $(this).parent();
                $(target).slideToggle();
                $(target2).toggleClass("active");
            });
        },

        slickSlider: function () {
            $('.home-one-testimonial-activator').slick({
                dots: false,
                infinite: true,
                arrows: false,
                autoplaySpeed: 3500,
                speed: 1500,
                slidesToShow: 2,
                slidesToScroll: 1,
                centerMode: false,
                autoplay: true,
                responsive: [
                    {
                        breakpoint: 768,
                        settings: {
                            slidesToShow: 2,
                            slidesToScroll: 2
                        }
                    }, 
                    {
                    breakpoint: 577,
                        settings: {
                            slidesToShow: 1,
                            slidesToScroll: 1
                        }
                    }
                ]
            });

            $('.course-activation').slick({
                dots: true,
                infinite: true,
                arrows: false,
                speed: 500,
                slidesToShow: 3,
                slidesToScroll: 1,
                centerMode: false,
                responsive: [
                    {
                        breakpoint: 992,
                        settings: {
                            slidesToShow: 2
                        }
                    }, 
                    {
                        breakpoint: 768,
                        settings: {
                            slidesToShow: 1
                        }
                    }
                ]
            });

            $('.testimonial-activation').slick({
                dots: true,
                infinite: true,
                arrows: false,
                speed: 500,
                slidesToShow: 3,
                slidesToScroll: 1,
                centerMode: false,
                autoplay: true,
                responsive: [
                    {
                        breakpoint: 992,
                        settings: {
                            slidesToShow: 2,
                            slidesToScroll: 1,
                        }
                    }, 
                    {
                        breakpoint: 768,
                        settings: {
                            slidesToShow: 1,
                            slidesToScroll: 1,
                        }
                    } 
                ]
            });

            $('.testimonial-activation-2').slick({
                dots: true,
                infinite: true,
                arrows: false,
                speed: 500,
                slidesToShow: 2,
                slidesToScroll: 1,
                centerMode: false,
                autoplay: true,
                responsive: [  
                    {
                        breakpoint: 768,
                        settings: {
                            slidesToShow: 1,
                            slidesToScroll: 1,
                        }
                    }, 
                ]
            });

            $('.testimonial-activation-3').slick({
                infinite: false,
                arrows: true,
                speed: 500,
                slidesToShow: 2,
                slidesToScroll: 1,
                autoplay: true,
                appendArrows: '.slick-arrow-nav',
                prevArrow: '<button type="button" class="slick-prev"><i class="icon-west"></i></button>',
                nextArrow: '<button type="button" class="slick-next"><i class="icon-east"></i></button>',
                responsive: [  
                    {
                        breakpoint: 577,
                        settings: {
                            slidesToShow: 1,
                            slidesToScroll: 1,
                        }
                    }, 
                ]
            });  

            $('.testimonial-activation-4').slick({
                dots: true,
                infinite: true,
                arrows: false,
                speed: 500,
                slidesToShow: 1,
                slidesToScroll: 1,
                centerMode: true,
                autoplay: true,
                responsive: [  
                    {
                        breakpoint: 768,
                        settings: {
                            slidesToShow: 1,
                            slidesToScroll: 1,
                        }
                    }, 
                ]
            }); 

            $('.testimonial-activation-5').slick({
                dots: true,
                infinite: true,
                arrows: false,
                speed: 500,
                slidesToShow: 1,
                slidesToScroll: 1,
                centerMode: false,
                autoplay: true,
                
            });

            $('.blog-gallery-activation').slick({
                dots: false,
                infinite: true,
                arrows: true,
                speed: 500,
                slidesToShow: 1,
                slidesToScroll: 1,
                prevArrow: '<button type="button" class="slick-prev"><i class="icon-west"></i></button>',
                nextArrow: '<button type="button" class="slick-next"><i class="icon-east"></i></button>'
               
            });
        },

        swiperSlider: function () {
            const swiperTestimonial2 = new Swiper('.swiper-testimonial-slider-wrapper', {
                loop: true,
                speed: 500,
                // autoplay: false,
                slidesPerView: 1,
                centeredSlides: true,
                effect: 'coverflow',
                autoplay: {
                    delay: 4000
                },
                breakpoints: {
                    575: {
                      slidesPerView: 2
                    }
                },
                coverflowEffect: {
                    rotate: 0,
                    slideShadows: false,
                    depth: 180,
                    stretch: 80
                },
                pagination: {
                    el: '.swiper-pagination',
                    type: 'bullets',
                    clickable: true
                }
            });
        },

        // counterUp: function () {
        //     $( '.counter-item' ).each(function () {
        //         $(this).isInViewport(function (status) {
        //             if (status === 'entered' ) {
        //                 for (var i = 0; i < document.querySelectorAll( '.odometer' ).length; i++) {
        //                     var el = document.querySelectorAll( '.odometer' )[i];
        //                     el.innerHTML = el.getAttribute( 'data-odometer-final' );
        //                 }
        //             }
        //         });
        //     });
        // },

        masonryActivation: function () {
             $('.isotope-wrapper').imagesLoaded(function () {
                // filter items on button click
                $('.isotop-filter').on('click', 'button', function () {
                    var filterValue = $(this).attr('data-filter');
                    $grid.isotope({
                        filter: filterValue
                    });
                });
                
                // init Isotope
                var $grid = $('.isotope-list').isotope({
                    itemSelector: '.isotope-item',
                    percentPosition: true,
                    transitionDuration: '0.7s',
                    layoutMode: 'fitRows',
                    masonry: {
                        // use outer width of grid-sizer for columnWidth
                        columnWidth: 1,
                    }
                });
            });
        
            $('.isotop-filter').on('click', 'button', function (event) {
                $(this).siblings('.is-checked').removeClass('is-checked');
                $(this).addClass('is-checked');
                event.preventDefault();
            });

            // Masonry
            var masonryContainer = $('#masonry-gallery');
            if (masonryContainer.length) {
                var masonryGallery = masonryContainer.imagesLoaded(function () {
                    masonryGallery.isotope({
                        itemSelector: '.masonry-item',
                        masonry: {
                            columnWidth: '.masonry-item'
                        }
                    });
                });
            }
        },

        // lightboxActivation: function() {
        //     lightGallery(document.getElementById('animated-thumbnials'), {
        //         thumbnail: true,
        //         animateThumb: false,
        //         showThumbByDefault: false
        //     });
        // },

        qtyBtn: function () {
            $('.pro-qty').prepend('<span class="dec qtybtn">-</span>');
            $('.pro-qty').append('<span class="inc qtybtn">+</span>');
            $('.qtybtn').on('click', function () {
                var $button = $(this);
                var oldValue = $button.parent().find('input').val();
                if ($button.hasClass('inc')) {
                    var newVal = parseFloat(oldValue) + 1;
                } else {
                    // Don't allow decrementing below zero
                    if (oldValue > 0) {
                        var newVal = parseFloat(oldValue) - 1;
                    } else {
                        newVal = 0;
                    }
                }
                $button.parent().find('input').val(newVal);
            });
        },

        mouseMoveAnimation: function () {
            $( '.scene' ).each(function () {
                new Parallax($(this)[0]);
            });
        },

        

        searchPopup: function () {
            $( '.search-trigger' ).on( 'click', function () {
                $( '.edu-search-popup' ).addClass( 'open' )
            } )
            $( '.close-trigger' ).on('click', function () {
                $( '.edu-search-popup' ).removeClass( 'open' )
            } )
            $( '.edu-search-popup' ).on( 'click', function () {
                $('.edu-search-popup').removeClass( 'open' );
            } )
            $( '.edu-search-popup .edublink-search-popup-field' ).on( 'click', function (e) {
                e.stopPropagation();
            } )
        },

        filterClickButton: function () {
            $('#slider-range').slider({
                range: true,
                min: 10,
                max: 500,
                values: [100, 300],
                slide: function (event, ui) {
                    $('#amount').val('$' + ui.values[0] + ' - $' + ui.values[1]);
                }
            });
            $('#amount').val('$' + $('#slider-range').slider('values', 0) +
                " - $" + $('#slider-range').slider('values', 1));
        },

        svgVivusAnimation: function () {
            SVGInject( document.querySelectorAll( 'img.svgInject' ), {
                makeIdsUnique: true,
                afterInject: function ( _, svg ) {
                    new Vivus( svg, {
                        duration: 80
                    } );
                }
            } );
            
            // Vivus Hover JS
            $( '.edublink-svg-animate' ).hover( function () {
                var svg = $( this ).find( 'svg' )[0];
                new Vivus( svg, {
                    duration: 50
                } );
            } )
        },

        countdownInit: function(countdownSelector, countdownTime) {
            var eventCounter = $(countdownSelector);
            if (eventCounter.length) {
                eventCounter.countdown(countdownTime, function(e) {
                    $(this).html(
                        e.strftime(
                            "<div class='countdown-section'><div><div class='countdown-number day'>%D</div> <div class='countdown-unit'>Day%!D</div> </div></div><div class='countdown-section'><div><div class='countdown-number hour'>%H</div> <div class='countdown-unit'>Hrs%!H</div> </div></div><div class='countdown-section'><div><div class='countdown-number minute'>%M</div> <div class='countdown-unit'>Mints</div> </div></div><div class='countdown-section'><div><div class='countdown-number second'>%S</div> <div class='countdown-unit'>Sec</div> </div></div>"
                        )
                    );
                });
            }
        },

        contactForm: function () {
            $('.rwt-dynamic-form').on('submit', function (e) {
				e.preventDefault();
				var _self = $(this);
				var __selector = _self.closest('input,textarea');
				_self.closest('div').find('input,textarea').removeAttr('style');
				_self.find('.error-msg').remove();
				_self.closest('div').find('button[type="submit"]').attr('disabled', 'disabled');
				var data = $(this).serialize();
				$.ajax({
					url: 'mail.php',
					type: "post",
					dataType: 'json',
					data: data,
					success: function (data) {
						_self.closest('div').find('button[type="submit"]').removeAttr('disabled');
						if (data.code == false) {
							_self.closest('div').find('[name="' + data.field + '"]');
							_self.find('.rn-btn').after('<div class="error-msg"><p>*' + data.err + '</p></div>');
						} else {
							$('.error-msg').hide();
							$('.form-group').removeClass('focused');
							_self.find('.rn-btn').after('<div class="success-msg"><p>' + data.success + '</p></div>');
							_self.closest('div').find('input,textarea').val('');

							setTimeout(function () {
								$('.success-msg').fadeOut('slow');
							}, 5000);
						}
					}
				});
			});
        }
    }

    eduJs.i();

})(window, document, jQuery)


