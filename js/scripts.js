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

	// Center gallery images
	var galpic = $('.gal-pic:nth-child(1)'),
	galpicWidth = galpic.width();	
	
	// Activate flowtype
/*	$("body").flowtype({
		minFont:16,
		maxFont:40,
		fontRatio:65
	});
	$('#relatedFacts>p').flowtype({
		minimum   : 200,
		maximum   : 1200,
		minFont   : 14,
		maxFont   : 200,
		fontRatio : 30
	});*/

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
	
	if(winWidth<900){
		$('.navbar.news .btn-group a').removeClass("selected");
		$('.navbar.news .btn-group a#list').addClass("selected");
		$('#news-gallery .item').addClass("list-group-item");
	}
	
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
	$('#main-menu-wrapper').toggle( "fast");
	var footerOffset = $('.footer').offset(),
		hdrHeight = $('#header').height(),
		offsetVal = footerOffset.top - hdrHeight;
		$('#menu').css("height", offsetVal);
}
// Menu Item Focus
function mif(data){
	var thisEl = data,
	parentEl = $(thisEl).parent(),
	currArrow = $(parentEl).find('.arrow');
	$(currArrow).css('backgroundPosition', "-11px,0");
}
// Menu Item Unfocus
function miu(data){
	var thisEl = data,
	parentEl = $(thisEl).parent(),
	currArrow = $(parentEl).find('.arrow');
	$(currArrow).css('backgroundPosition', "0,0");
}
// Menu Item Select
function mis(data){
	var thisEl = data,
	parentEl = $(thisEl).parent(),
	currArrow = $(parentEl).find(".arrow");
	$('#menu .arrow, #menu input').removeClass("selected");
	$(thisEl).addClass("selected");
	$(currArrow).addClass("selected");
}

// News Items
function hover(el){
	var currEl = el,
	target = $(currEl).parent().parent().parent();
	$(target).addClass("highlighted");
};
function hoverOut(el){
	var currEl = el,
	target = $(currEl).parent().parent().parent();
	$(target).removeClass("highlighted");
};
function gotoArticle(el){
	var currEl = el,
	parentEl = $(currEl).parent(),
	target = $(parentEl).attr("href");
	alert(target);
}