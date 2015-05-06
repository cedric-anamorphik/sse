/*+++++++++++*/
/* SIDEBAR
/*+++++++++++*/	
// CLOCK for the countdown section	
function TimeCtrl($scope, $timeout) {
$scope.clock = "Loading the current time...";
$scope.tickInterval = 1000;
var tick = function() {
	$scope.clock = Date.now()
	$timeout(tick, $scope.tickInterval);
}
// Start the timer
$timeout(tick, $scope.tickInterval);
}

/*++++++++++++++*/
/* DETECT DEVICE
/*++++++++++++++*/
var devDetect = {
    Android: function() {
        return navigator.userAgent.match(/Android/i);
    },
    BlackBerry: function() {
        return navigator.userAgent.match(/BlackBerry/i);
    },
    iPhone: function() {
        return navigator.userAgent.match(/iPhone/i);
    },
	iPad: function() {
        return navigator.userAgent.match(/iPad/i);
    },
	iPod: function() {
        return navigator.userAgent.match(/iPod/i);
    },
	// Detect any iOS device
	// iOS: function() {
        // return navigator.userAgent.match(/iPhone|iPad|iPod/i);
    // }
    Opera: function() {
        return navigator.userAgent.match(/Opera Mini/i);
    },
    Windows: function() {
        return navigator.userAgent.match(/IEMobile/i);
    },
	// Detect any mobile device
    any: function() {
        return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iPhone() || isMobile.iPad() || isMobile.iPod() || isMobile.Opera() || isMobile.Windows());
    }
};

/*++++++++++++++*/
/* iPad DETECTED
/*++++++++++++++*/
// if(devDetect.iPad()){
	// checkOrientation();
	
	// Check device orientation
	// $(window).on('orientationchange', function(event) {
        // stackEm();
    // });
// };

// function checkOrientation(){
	// if(window.innerHeight > window.innerWidth){
		 // Portrait mode
	// } else if (window.innerWidth > window.innerHeight){
		// Landscape mode
	// }
// };

// function stackEm(){
	// if(window.innerHeight > window.innerWidth){
		 // Portrait mode
		 // $('#pageContent').toggleClass("col-sm-7 col-sm-12");
		 // $('#sidebar-second').toggleClass("col-sm-5 col-sm-12");
	// } else if (window.innerWidth > window.innerHeight){
		// Landscape mode
		// $('#pageContent').toggleClass("col-sm-12 col-sm-7");
		// $('#sidebar-second').toggleClass("col-sm-12 col-sm-5");
	// }
// };

/*+++++++++++++++++*/
/* DOCUMENT READY
/*+++++++++++++++++*/
$(document).ready(function(){

	$('#header').removeClass("navbar-fixed-top");
	// Center gallery images
	var galpic = $('.gal-pic:nth-child(1)'),
	galpicWidth = galpic.width();

	// Search field in header
	var searchVis = 0;
	$('#user-menu').delegate('.btn-search', 'click', function(){
		var winWidth = $(window).width();
		if(winWidth >= 863 && searchVis==0){
			console.log("Greater than 863");
			$('#search-form>input').css('background-color', '#222').css("height", "33px").css("padding-left", "10px").css("border-width", "1px 0 1px 1px").css('border-style', 'solid').css('border-color', '#3e608d');
			$('div.sse-hdr-title').css("width", "310px");
			$('div.sse-hdr-title').animate({right: '288px'}, 400);
			$('#search-form>input').animate({width: '178px'}, 400);
			$('#user-menu').animate({width: '264px'}, 400, function(){searchVis = 1;});
		} else if(winWidth > 751 && winWidth < 863 && searchVis==0){
			console.log("Greater than 751 and less than 863");
			$('div.sse-hdr-title').css("display", "none").css("opacity", "0");
			$('#search-form>input').css('background-color', '#222').css("height", "33px").css("padding-left", "10px").css("border-width", "1px 0 1px 1px").css('border-style', 'solid').css('border-color', '#3e608d');
			$('#search-form>input').animate({width: '178px'}, 400);
			$('#user-menu').animate({width: '264px'}, 400, function(){searchVis = 1;});
		} else if(winWidth > 400 && winWidth < 751 && searchVis==0){
			console.log("Less than 751");
			$('div.sse-hdr-title').css("display", "none").css("opacity", "0");
			$('#search-form>input').css('background-color', '#222').css("height", "33px").css("padding-left", "10px").css("border-width", "1px 0 1px 1px").css('border-style', 'solid').css('border-color', '#3e608d');
			$('#search-form>input').animate({width: '178px'}, 400);
			$('#user-menu').animate({width: '264px'}, 400, function(){searchVis = 1;});
		} else if(winWidth < 400 && searchVis==0){
			$('.navbar-brand>img').css("opacity", "0");
			$('#search-form>input').css('background-color', '#222').css("height", "33px").css("padding-left", "10px").css("border-width", "1px 0 1px 1px").css('border-style', 'solid').css('border-color', '#3e608d');
			$('#search-form>input').animate({width: '157px'}, 400);
			$('#user-menu').animate({width: '264px'}, 400, function(){searchVis = 1;});
		};
		
		if(searchVis==1){
			var searchData = 0;
			$('#search-form>input').css("borderWidth", "0").css("height", "0px").css("width", "0px").css('background-color', 'transparent');
			$('#user-menu').css("width", "104px");
			$('div.sse-hdr-title').css("display", "block");
			$('#search-form>input').val('');
			if(winWidth >= 863){
				$('div.sse-hdr-title').animate({right: '129px'}, 400);
			} else if(winWidth > 751 && winWidth < 863){
				$('div.sse-hdr-title').animate({opacity: '1'}, 400);
			} else if(winWidth > 400 && winWidth < 751){
				$('div.sse-hdr-title').css("display", "none");
			} else if(winWidth < 400){
				$('.navbar-brand>img').animate({opacity: '1'}, 400);
				$('div.sse-hdr-title').css("display", "none");
			}
			searchVis = 0;
		};
	});
	
	// Expand social icons
	$('#user-menu').delegate('.btn-search', 'click', function(){
		$('gallery-sectionbar a>img').css("width", "20px");
	});
	
	// Home button in main menu link-fix
	$('#menu').delegate('.menu-item:first-child input', 'click', function(){
		window.location.href = "#/";
	});
	
	// This is the connector function.
	// It connects one item from the navigation carousel to one item from the
	// stage carousel.
	// The default behaviour is, to connect items with the same index from both
	// carousels. This might _not_ work with circular carousels!
	// var connector = function(itemNavigation, carouselMain) {
		// return carouselMain.jcarousel('items').eq(itemNavigation.index());
	// };

	// Setup the carousels. Adjust the options for both carousels here.
	// var carouselMain      = $('.carousel-main').jcarousel();
	// console.log(carouselMain);
	// var carouselNavigation = $('.carousel-navigation').jcarousel();
	// console.log(carouselNavigation);

	// We loop through the items of the navigation carousel and set it up
	// as a control for an item from the stage carousel.
	// carouselNavigation.jcarousel('items').each(function() {
		// var item = $(this);

	// This is where we actually connect to items.
	// var target = connector(item, carouselMain);

	// item
		// .on('jcarouselcontrol:active', function() {
			// carouselNavigation.jcarousel('scrollIntoView', this);
			// item.addClass('active');
			// var label = item.find('.navigation-label').html();
			// $('.active-label').html(label);
		// })
		// .on('jcarouselcontrol:inactive', function() {
			// item.removeClass('active');
		// })
		// .jcarouselControl({
			// target: target,
			// carousel: carouselMain
		// });
	// });

	// Setup controls for the stage carousel
	// $('.prev-main')
	// .on('jcarouselcontrol:inactive', function() {
		// $(this).addClass('inactive');
	// })
	// .on('jcarouselcontrol:active', function() {
		// $(this).removeClass('inactive');
	// })
	// .jcarouselControl({
		// target: '-=1'
	// });

	// $('.next-main')
	// .on('jcarouselcontrol:inactive', function() {
		// $(this).addClass('inactive');
	// })
	// .on('jcarouselcontrol:active', function() {
		// $(this).removeClass('inactive');
	// })
	// .jcarouselControl({
		// target: '+=1'
	// });

});

/*+++++++++++++++*/
/* WINDOW RESIZE
/*+++++++++++++++*/
$(window).resize(function(){
	
	// Search form resize ctrl
	var searchWidth = $('#search-form>input').width(),
	earthVis = $('.navbar-brand>img').css("opacity"),
	sseTitleVis = $('div.sse-hdr-title').css("display"),
	winWidth = $(window).width();
	
	if(searchWidth>0 && winWidth > 751 && winWidth <= 863){
		$('div.sse-hdr-title').css("display", "none");
	} else if(searchWidth>=0 && winWidth > 400 && winWidth <= 751){
		$('.navbar-brand>img').animate({opacity: '1'}, 300);
		$('div.sse-hdr-title').css("display", "none");
		$('#search-form>input').css("border", "0").css("height", "0px").css("width", "0px");		
	} else if(searchWidth==0 && winWidth > 751 && winWidth < 863){
		$('div.sse-hdr-title').css("display", "block").css("right", "129px");
		$('div.sse-hdr-title').animate({opacity: '1'}, 300);
	} else if(earthVis==0 && searchWidth==0 && winWidth < 400){
		$('#search-form>input').css("border", "0").css("height", "0px").css("width", "0px");
		$('.navbar-brand>img').animate({opacity: '1'}, 400);
	} else if(earthVis==1 && searchWidth>0 && winWidth < 400){
		$('.navbar-brand>img').animate({opacity: '0'}, 400);
	};
	
	// Set celestial filter panel height
	var cfpTargetHeight = $('#sseGallery').css("height"),
	hParsed = parseInt($('#sseGallery').css('height'), 10),
	cfpHeight = hParsed,
	celestialFilterPnl = $('#celestial-panel-wrapper');
	
	$('#celestial-filterpanel').css("height", cfpHeight);
	$('#celestial-panel-wrapper').css("height", cfpHeight);
	
	var footerOffset = $('.footer').offset(),
		hdrHeight = $('#header').height(),
		offsetVal = footerOffset.top - hdrHeight;
		$('#menu').css("height", offsetVal);
	
	var pathname = window.location.pathname;
	if (pathname == "/devel/sse/dev/" || "/devel/sse/staging/"){
		var windowH = $(window).height(),
		headerH = $('#header').height(),
		targetH = windowH-headerH;
		$("#menu").css("height", targetH);
	}
	
	$('#sseGallery.people').find('.item .img-window').each(function(){
		var thisEl = $(this);
		if(winWidth < 1215){
			var imgWidth = $(thisEl).width();
			$(thisEl).css("height", imgWidth);
		} else {
			$(thisEl).css("height", "319px");
		}
	});
	
	$('#sseGallery.people .item').find('img.img-responsive').each(function(){
		var thisEl = $(this),
		parentEl = $(thisEl).parent(),
		imgHeight = $(thisEl).height(),
		imgWidth = $(thisEl).width(),
		parentHeight = $(parentEl).height(),
		imgGradient = $(parentEl).find('.txt-bg');
		
		if(imgHeight < parentHeight){
			$(imgGradient).css("height", "50%");
			var gradHeight = $(imgGradient).height(),
				offset = (imgHeight - gradHeight) + 1;
			$(imgGradient).css("top", offset);
		} else {
			$(imgGradient).css("height", "100%");
			$(imgGradient).css("top", "0");
		}
	});
	
	$('#sseGallery.galleries .item').find('img.img-responsive').each(function(){
		var thisEl = $(this),
		parentEl = $(thisEl).parent(),
		imgHeight = $(thisEl).height(),
		parentHeight = $(parentEl).height(),
		imgGradient = $(parentEl).find('.txt-bg');
		
		if(imgHeight < parentHeight){
			$(imgGradient).css("height", "50%");
			var gradHeight = $(imgGradient).height(),
				offset = (imgHeight - gradHeight) + 1;
			$(imgGradient).css("top", offset);
		} else {
			$(imgGradient).css("height", "100%");
			$(imgGradient).css("top", "0");
		}
	});
	
	txtResponsive();
});

/*+++++++++++++++++++++++*/
/* PLANETARY FILTER PANEL
/*++++++++++++++++++++++*/
// Expand celestial filter panel
function cfp(){
	var cfpTargetHeight = $('#sseGallery').height(),
	cfpHeight = cfpTargetHeight;
	$('#celestial-filterpanel').animate({right: '0px'}, 250).css("height", cfpHeight);
	$('#celestial-panel-wrapper').css("height", cfpHeight);
	$('#celestial-panel-wrapper').css("z-index", "4");
	$('#celestial-filterpanel').css("display", "block");
	$('#filter-panel-wrapper').css("z-index", "0");
}

function ccfp(){
	$('#celestial-filterpanel').animate({right: '-469px'}, 250, function(){
		$('#filter-panel-wrapper').css("z-index", "5");
		$('#celestial-panel-wrapper').css("z-index", "0");
	});
}

//Celestial Filtering
function checkState(checkbox){
	var chkBox = checkbox,
	checkAttr = $(checkbox).attr("data-filter"),
	checkGroup = $(checkbox).attr("data-group"),
	// optChecked = $('.img-gallery').children('.celestial.'+checkAttr),
	// optUnchecked = $('.img-gallery .celestial').not('.celestial.'+checkAttr),
	galLists = $('.gal-container').find('.img-gallery'),
	galListLength = $(galLists).length,
	grid = $('.shuffle-grid');

		
	// filter
	if(checkbox.checked == 1){
		// Shuffle options
		grid.shuffle({
			itemSelector: '.item',
			speed: 300,
			sizer: '.shuffle-grid',
			buffer: 0,
			throttleTime: 300
		});
		
		// reshuffle grid
		grid.shuffle('shuffle', checkGroup);
		
	}
	if(checkbox.checked == 0){
		grid.shuffle('shuffle', 'all');
	};
};

// Gallery sorting
function sortItOut(e){
	var checkSort = $(e).attr("data-sort"),
	grid = $('.shuffle-grid'),
	opts = {};

	// Reset sort
	if(e.checked == 0){
		grid.shuffle('sort', {});
	}
	
	// Sort by size
	if(checkSort == "size"){
		opts={
			reverse: true,
			by: function(){
				return $('.item.filtered');
			}
		}
		grid.shuffle('sort', opts);
	};
};

// Gallery Sections toggle
function hideGalHeaders(checkbox){
	var galLists = $('.gal-container').find('.img-gallery'),
	checkSort = $(checkbox).attr("data-sort"),
	galListLength = $(galLists).length,
	galHeaders = $('.gal-container').find('.gal-header'),
	celestialFilterPnl = $('#celestial-panel-wrapper');
	vizList = $('.item.filtered');
	
	if(checkbox.checked == 1){
		$('.item.filtered').removeClass("top");
		$('.item.filtered').css("position", "relative");
		vizList.css("transform", "");
		vizList.css("top", "auto");
		vizList.css("left", "auto");
		vizList.css("position", "relative");
		
		for(i=0;i<galListLength;i++){
			var listContainer = $('.gal-container .img-gallery')[i],
			divList = $(listContainer).children('.gal-pic');
			
			// Sort by size
			if(checkSort == "size"){
				opts={
					reverse: true,
					by: function(){
						return $('.item.filtered');
					}
				}
				grid.shuffle('sort', opts);
			};
			
			$('.gal-container').prepend(divList);
			// $('.gal-container').prepend(celestialFilterPnl);
			$('.gal-container').addClass("shuffle-grid");
			// $('#filter-btn-wrapper').insertAfter(celestialFilterPnl);
		};
		galHeaders.css("display", "none");
	};
	
	if(checkbox.checked == 0){
		//vizList.css("position", "absolute");
		$('.gal-container').find('.gal-pic').each(function(){
			var section=$($(this)).data("section");
			// Reset categories
			$('#'+section).prepend($(this));
			$('.gal-header').css("display", "block");
			$('.gal-container').removeClass("shuffle-grid");
		});
	};
};

/*++++++++++++++++++*/
/* Planetary Legend
/*+++++++++++++++++*/
function iconHover(data){
	var e = data,
	parentEl = $(e).parent().parent(),
	thisEl = $(e).find('div.icon>img'),
	childListEl = $(parentEl).find('p.list-item');
	$(childListEl).css("color", "#caab30");
	$(thisEl).css("position", "relative").css("left", "-133px").css("cursor", "pointer");
};

function iconStandard(data){
	var e = data;
	parentEl = $(e).parent().parent(),
	thisEl = $(e).find('div.icon>img'),
	childListEl = $(parentEl).find('p.list-item');
	$(childListEl).css("color", "#3569a4");
	$(thisEl).css("position", "relative").css("left", "0");
};

function itemHover(data){
	var e = data,
	thisEl = $(e).find('p.list-item'),
	parentEl = $(e).parent().parent(),
	childListEl = $(parentEl).find('div.icon>img');
	$(childListEl).css("position", "relative").css("left", "-133px");
	$(thisEl).css("color", "#caab30").css("cursor", "pointer");
};

function itemStandard(data){
	var e = data;
	thisEl = $(e).find('p.list-item'),
	parentEl = $(e).parent().parent(),
	childListEl = $(parentEl).find('div.icon>img');
	$(childListEl).css("position", "relative").css("left", "0");
	$(thisEl).css("color", "#3569a4");
};

/*+++++++++++*/
/* Main Menu
/*+++++++++++*/
function mm(){
	$('#menu .menu-item:first-child div.panel-collapse').remove();
	$('#main-menu-wrapper').toggle( "fast");
	var footerOffset = $('.footer').offset(),
		hdrHeight = $('#header').height(),
		offsetVal = footerOffset.top - hdrHeight;
		$('#menu').css("height", offsetVal);
	var pathname = window.location.pathname;
	if (pathname == "/devel/sse/dev/" || "/devel/sse/staging/"){
		var windowH = $(window).height(),
		headerH = $('#header').height(),
		targetH = windowH-headerH;
		$("#menu").css("height", targetH);
	}
}
// Menu Item Focus
function mif(data){
	var thisEl = data,
	parentEl = $(thisEl).parent(),
	currArrow = $(parentEl).find('.arrow'),
	currSel = $(parentEl).find('.arrow.selected');
	if($(currArrow).hasClass("selected")){
		$(currArrow).css('backgroundPosition', "-22px,0");
	} else {
		$(currArrow).css('backgroundPosition', "-11px,0");
	}	
}
// Menu Item Unfocus
function miu(data){
	var thisEl = data,
	parentEl = $(thisEl).parent(),
	currArrow = $(parentEl).find('.arrow'),
	currSel = $(parentEl).find('.arrow.selected');
	if($(currArrow).hasClass("selected")){
		$(currArrow).css('backgroundPosition', "-22px,0");
	} else {
		$(currArrow).css('backgroundPosition', "0,0");
	}
}
// Menu Item Select
function mis(data){
	var thisEl = data,
	parentEl = $(thisEl).parent(),
	currArrow = $(parentEl).find(".arrow");
	$('#menu .arrow, #menu input').removeClass("selected");
	$('#menu .arrow').css('backgroundPosition', "0,0");
	if (!$(thisEl).hasClass("selected")){
		$(thisEl).addClass("selected");
		$(currArrow).addClass("selected");
	} else {
		$(thisEl).removeClass("selected");
		$(currArrow).removeClass("selected");
	}
	$(currArrow).css('backgroundPosition', "-22px,0");
}

/*+++++++++++++++++++++++*/
/* People Landing Gallery
/*++++++++++++++++++++++*/
function checkSize_people(data){
	var thisEl = data,
		parentEl = $(thisEl).parent(),
		imgHeight = $(thisEl).height(),
		imgGradient = $(parentEl).find('.txt-bg');
		
		if(imgHeight < 319){
			$(imgGradient).css("height", "50%");
			var gradHeight = $(imgGradient).height(),
				offset = (imgHeight - gradHeight) + 1;
			$(imgGradient).css("top", offset);
		} else {
			$(imgGradient).css("height", "100%");
			$(imgGradient).css("top", "0");
		}
};

/*+++++++++++++++++++++++++*/
/* Galleries Landing Gallery
/*++++++++++++++++++++++++*/
function checkSize_galleries(data){
	var e = data,
		p = $(e).parent(),
		iH = $(e).height(),
		g = $(p).find('.txt-bg'),
		WW = $(window).innerWidth(),
		iW = $('#sseGallery.galleries .item').width(),
		itmH = iW*.69;
		
		if(WW < 1215){
			$('#sseGallery.galleries').find('.item').css("height", itmH);
			$('#sseGallery.galleries').find('.img-window').css("height", itmH);
			$('#sseGallery.galleries').find('a').css("height", itmH);
		}
		
		if(iH < 224){
			$(g).css("height", "50%");
			var gradHeight = $(g).height(),
				offset = (iH - gradHeight) + 1;
			$(g).css("top", offset);
		} else {
			$(g).css("height", "100%");
			$(g).css("top", "0");
		}
};
function loadInteractivity(){
	$('#sseGallery.galleries').delegate('.item .l2', 'click', function(event){
		event.preventDefault();
		var i = $(event.target).closest(".item").data("id");
		
	});
}

function setGalleryItemShadow(){
	$('#sseGallery .item').find('.img-responsive').each(function(){
		var e = $(this),
		p = $(e).parent(),
		iH = $(e).height(),
		pH = $(p).height(),
		g = $(p).find('.txt-bg');
		
		if(iH < pH){
			$(g).css("height", "50%");
			var gH = $(g).height(),
				offset = (iH - gH) + 1;
			$(g).css("top", offset);
		} else {
			$(g).css("height", "100%");
			$(g).css("top", "0");
		}
	});
}

/*++++++++++++++++++++++*/
/* News Landing Gallery
/*++++++++++++++++++++++*/
// News Items
function newsHover(el){
	var e = el,
		t = $(e).parent().parent();
	$(t).addClass("highlighted");
};
function newsHoverOut(el){
	var e = el,
		t = $(e).parent().parent();
	$(t).removeClass("highlighted");
};
function gotoArticle(el){
	var e = el,
		p = $(e).parent(),
		t = $(p).attr("href");
}

$('#factoids-carousel').on('slide.bs.carousel', function (event) {
	alert("msg");
	var active = $(event.target).find('.carousel-inner > .item.active');
	var from = active.index();
	var next = $(event.relatedTarget);
	var to = next.index();
	var direction = event.direction;
});

// Detect Gallery BS State
function checkGalState(){
	var state,
		scale,
		itmH,
		inrH,
		galW = $('body').find('.img-gallery').width(),
		lState = $('#sseGallery .btn-group #list'),
		gState = $('#sseGallery .btn-group #grid'),
		WW = $(window).innerWidth();
	
	if ($(lState).hasClass("selected") && WW > 600){
		$('#sseGallery .item').addClass('list-group-item');
		$('#sseGallery .item .gal-name').addClass("notransition");
		$('#sseGallery .btn-group').css("display", "inline-block");
	} else if($(lState).hasClass("selected") && WW < 600){
		$('#sseGallery .item').removeClass('list-group-item');
		$('#sseGallery .item .gal-name').removeClass("notransition");
		$('#sseGallery .btn-group').css("display", "none");
	};
	
	if(isBreakpoint('xs')){
		state = "xs";
		scale = "1";
		itmH = galW * scale;
		inrH = itmH - 25;
		$('#sseGallery .item').css('height', itmH);
		$('#sseGallery .item .img-window').css('height', inrH);
		$('#sseGallery .item .img-window').css('width', inrH);
		$('#sseGallery .item .item-ovrly').css('height', inrH);
		$('#sseGallery .item .item-ovrly').css('width', inrH);
		$('#sseGallery .item .txt-background').css('height', inrH);
		$('#sseGallery .item .txt-background').css('width', inrH);
		if ($(gState).hasClass("selected")){
			$('#sseGallery .btn-group').css("display", "none");
		}
		setGalleryItemShadow();
	};
	
	if(isBreakpoint('sm')){
		state = "sm";
		scale = ".5";
		itmH = galW * scale;
		inrH = itmH - 25;
		$('#sseGallery .item').css('height', itmH);
		$('#sseGallery .item .img-window').css('height', inrH);
		$('#sseGallery .item .img-window').css('width', inrH);
		$('#sseGallery .item .item-ovrly').css('height', inrH);
		$('#sseGallery .item .item-ovrly').css('width', inrH);
		$('#sseGallery .item .txt-background').css('height', inrH);
		$('#sseGallery .item .txt-background').css('width', inrH);
		$('#sseGallery .btn-group').css("display", "inline-block");
		setGalleryItemShadow();
	};
	if(isBreakpoint('md')){
		state = "md";
		scale = ".33";
		itmH = galW * scale;
		inrH = itmH - 25;
		$('#sseGallery .item').css('height', itmH);
		$('#sseGallery .item .img-window').css('height', inrH);
		$('#sseGallery .item .img-window').css('width', inrH);
		$('#sseGallery .item .item-ovrly').css('height', inrH);
		$('#sseGallery .item .item-ovrly').css('width', inrH);
		$('#sseGallery .item .txt-background').css('height', inrH);
		$('#sseGallery .item .txt-background').css('width', inrH);
		setGalleryItemShadow();
	};
	if(isBreakpoint('lg')){
		state = "lg";
		scale = ".25";
		itmH = galW * scale;
		inrH = itmH - 25;
		$('#sseGallery .item').css('height', itmH);
		$('#sseGallery .item .img-window').css('height', inrH);
		$('#sseGallery .item .img-window').css('width', inrH);
		$('#sseGallery .item .item-ovrly').css('height', inrH);
		$('#sseGallery .item .item-ovrly').css('width', inrH);
		$('#sseGallery .item .txt-background').css('height', inrH);
		$('#sseGallery .item .txt-background').css('width', inrH);
		setGalleryItemShadow();
	};
};
function isBreakpoint(alias){
	return $('.device-' + alias).is(':visible');
}
	
/*++++++++++++++++++++++++++++++++++*/
/* Responsive Elliptical Truncating
/* Multi-Line-Support
/*+++++++++++++++++++++++++++++++++*/
// $('#user-menu .btn-search').on("click", multiParElliptical());
function multiParElliptical(){
	var cntnr = $('.par-elliptical');
	cntnr.html('<span>'+cntnr.html().replace(/ /g,'</span> <span>')+'</span>');
	var words = Array.prototype.slice.call(cntnr.find("span"),0);
	var lastw = null;
	for(var i=0,c=words.length;i<c;i++){
		var w = $(words[i]);
		var wbot = w.height() + w.offset().top;
		var wleft = w.position().left;
		var wright = wleft+w.width();
		console.log(wbot);
		if(wbot >= cntnr.height() && wleft <= cntnr.width()){
			w = $(words[i+1]);
			lastw = w.text("...");  
			break;
		}
	}
	cntnr.html(cntnr.text());
	console.log(lastw);
};

/*++++++++++++++*/
/* Squishy Text
/*++++++++++++++*/
function txtResponsive(){
	var a = $('.txt-cntnr'),
		b = $('.txt-responsive'),
		aW = $(a).width(),
		bW = parseInt($(b).css("font-size"), 10),
		sclRat,
		mainWidth = 1400,
		state,
		colVal;
		
	$(b).each(function(){
		var parentCntnr = $(this).closest($(a));
		sclRat = bW / aW;
		// console.log(sclRat);
	});
		
	if(isBreakpoint('xs')){
		state = "xs";
		// var classes = $(cntnr).attr('class').split(' ');
		// for (var i = 0; i < classes.length; i++) {
		  // var matches = /^col\-xs\-/.exec(classes[i]);
		// }
		// console.log(matches);
	};
	if(isBreakpoint('sm')){
		state = "sm";
		// var classes = $(cntnr).attr('class').split(' ');
		// for (var i = 0; i < classes.length; i++) {
		  // var matches = /^col\-sm\-/.exec(classes[i]);
		// }
		// console.log(matches);
	};
	if(isBreakpoint('md')){
		state = "md";
		// var classes = $(cntnr).attr('class').split(' ');
		// for (var i = 0; i < classes.length; i++) {
		  // var matches = /^col\-md\-/.exec(classes[i]);
		// }
		// console.log(matches);
	};
	if(isBreakpoint('lg')){
		state = "lg";
		// var classes = $(cntnr).attr('class').split(' ');
		// for (var i = 0; i < classes.length; i++) {
		  // var matches = /^col\-lg\-/.exec(classes[i]);
		// }
		// console.log(matches);
	};
};

/*++++++++++++++++++++++*/
/* Missions Landing Gallery
/*++++++++++++++++++++++*/
function setItemHeight(el){
		var e = el,
			p = $(e).parent().parent().parent(),
			iw = $(p).find('.img-window'),
			v = $(e).width();
			$(iw).css("height", v);
			setMissionsItemShadow();
		// if(v > 0){
			// $(i).css("height", v);
			// setMissionsItemShadow();
		// }
		/*+++++++++++++++*/
		/* WINDOW RESIZE
		/*+++++++++++++++*/
		$(window).resize(function(){
			v = $(e).width();
			// $(e).css("height", v);
			$(iw).css("height", v);
			setMissionsItemShadow();
		});
};
function setMissionsItemShadow(){
	$('#sseGallery.missions .item').find('.gal-image').each(function(){
		var e = $(this),
			p = $(e).parent(),
			iH = $(e).height(),
			pH = $(p).height(),
			g = $(p).find('.txt-bg');
		if(iH < pH){
			$(g).css("height", "50%");
			var gH = $(g).height(),
				o = (iH - gH) + 1;
			$(g).css("top", o);
		} else {
			$(g).css("height", "100%");
		}
	});
}