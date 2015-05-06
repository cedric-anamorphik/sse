// CORE CONTROLLERS
angular.module('sse.controllers', [])
	.controller('SSEdata', ['$scope', '$http', function ($scope, $http, $timeout) {
    $scope.data,
	$scope.people;
	$scope.currentProfile = 0;
	$scope.sbLinkClass = 'profileLink';
    var url = 'json/home-sidebar-json.cfm';
	$http.get(url)
	.success(function(data){
		$scope.data = data;
		$scope.people = data.people;
		$scope.currProfile = data.people[0];
		$scope.profileQuote = $scope.currProfile.quote;
	})
	.error(function(data, status, headers, config){
		console.log("We apologize, but the planetary information you requested is lost in space at the moment");
	})
	
	$scope.updateProfile = function(data){
		$scope.currentProfile = $('#slick-people').slickCurrentSlide();
		var activeSlide = $('#slick-people .slick-active')[0];
		var inactiveSlide1 = $('#slick-people .slick-active')[1];
		var inactiveSlide2 = $('#slick-people .slick-active')[2];
		$scope.currProfile = $scope.people[$scope.currentProfile];
		$scope.profileQuote = $scope.currProfile.quote;
		$(activeSlide).addClass("selected");
		$(inactiveSlide1).removeClass("selected");
		$(inactiveSlide2).removeClass("selected");
	}
	
	$scope.updateProfileClass = function(index){
		return 
	}
	
	}])
	.controller('PopCtrl', function ($scope, sidePopFactory) {
		sidePopFactory.get(function(data){
			$scope.planets = data.popPlanets;
			$scope.missions = data.popMissions;
			$scope.images = data.popImages;
			$scope.downloads = data.popDownloads;
			$scope.popPlanetsUrl = "images/popPlanets.jpg";
			$scope.popMissionsUrl = "images/popMissions.jpg";
			$scope.popImagesUrl = "images/popImages.jpg";
			$scope.popDownloadsUrl = "images/popDownloads.jpg";
			
			//SET popular planet's preview image
			$scope.updatePopImg = function(imageUrl) {
				var i = imageUrl;
				$scope.popPlanetsUrl  = data.popPlanets[i].url;
				$scope.popMissionsUrl  = data.popMissions[i].url;
				$scope.popImagesUrl  = data.popImages[i].url;
				$scope.popDownloadsUrl  = data.popDownloads[i].url;
			}
		});
		$scope.myInterval = 0;
	})
	.controller("SBNavCtrl", function ($scope) {
		$scope.doStuff = function (item) {
			//GET the current element's target value
			var e = angular.element(item).attr('scroller'),
			scrollTarget = document.getElementById(e);
			//SCROLL to the location
			scrollTarget.scrollIntoView();
		};
	})
	.controller('RelatedImageGal', function($scope, $timeout){
		$scope.fireEvent = function(){
			// This will only run after the ng-repeat has rendered its things to the DOM
			$timeout(function(){
				var img1 = $('.related-images-gallery').children('li')[0].children[0],
				img2 = $('.related-images-gallery').children('li')[4].children[0],
				val1 = img1.height,
				val2 = img2.height,
				galHeight = val1 + val2 + 24;
				$('.related-images-gallery').css("height", galHeight);
			}, 700);
		};
	})
	.controller('PlanetGalCtrl', function($scope, $timeout, planetsGalFactory){
		planetsGalFactory.get(function(data){
			$scope.galleryPlanets = data.galPlanets;
			$scope.gallerySmallBodies = data.galSmallBodies;
			$scope.galleryMoons = data.galMoons;
			$scope.galleryRegions = data.galRegions;
			$scope.galleryStars = data.galStars;
			$scope.sseLegend = data.sseLegend;			
		});
	})
	.controller('MissionGalCtrl', function($scope, missionsGalFactory){
		missionsGalFactory.get(function(data){
			$scope.missionLanding = data.missions_list;
		});
	})
	.controller('missionsDetailCtrl', function($scope, page_data){
		var data = page_data.data;
		$scope.missionDetails = data.missions_list;
	})
	.controller('MissionsTypeCtrl', function($scope, missionsTypeFactory){
		missionsTypeFactory.get(function(data){
			$scope.missionType = data.mission_types;
		});
	})
	.controller('MissionsTargetCtrl', function($scope, missionsTargetFactory){
		missionsTargetFactory.get(function(data){
			$scope.missionTarget = data.mission_targets;
		});
	})
	.controller('MainNavCtrl', function($scope, navFactory){
		navFactory.get(function(data){
			$scope.mainMenu = data.section;
		});
	})
	.controller('PeopleGalCtrl', function($scope, peopleGalFactory){
		peopleGalFactory.getPeople().then(function(data){
			$scope.people = data.people;
		});		
		
		var pagesShown = 1;
		var pageSize = 12;
		$('#sseGallery.people #less-wrapper').hide();
		$scope.peopleLimit = function() {
			return pageSize * pagesShown;
		};
		$scope.hasMorePeopleToShow = function() {
			return pagesShown < ($scope.people.length / pageSize);
		};
		$scope.showMorePeople = function() {
			pagesShown = pagesShown + 1;
			$('#sseGallery.people #less-wrapper').addClass('visible');
			$('#sseGallery.people #less-wrapper').show();
		};
		$scope.showLessPeople = function() {
				pagesShown = 1;
				$('#sseGallery.people #less-wrapper').removeClass("visible");
				$('#sseGallery.people #less-wrapper').hide();
			};
			/*+++++++++++++++++++*/
			/* WINDOW SCROLL CTRL
			/*++++++++++++++++++*/
			$(window).scroll(function(){
				
				// People Landing Page Scroll Ctrl
				var peopleGal = $('#sseGallery.people'),
					peopleLess = $('#sseGallery.people #less-wrapper.visible'),
					peopleLessBtn = $('#sseGallery.people #less-wrapper.visible button');
					
				$(document).on('scroll', function(){
					var	peopleLessTop = $('#sseGallery.people #less-wrapper').offset().top,
						peopleGalTop = $('#sseGallery.people').offset().top + 11,
						peopleLessPos = peopleGalTop - $(this).scrollTop();
					if(peopleLessPos < 0){
						$(peopleLess).addClass("fixed");
						$(peopleLessBtn).addClass("top-tab");
					}
					if($(this).scrollTop() < 154){
						$(peopleLess).removeClass("fixed");
						$(peopleLessBtn).removeClass("top-tab");
					}					
				});
			});
	})
	.controller('NewsGalCtrl', function($scope, newsGalFactory){
		newsGalFactory.getNews().then(function(data){
			$scope.news = data.news;
		});

		var pagesShown = 1,
			pageSize = 8,
			gw = $('#sseGallery.news'),
			iWW = $(window).innerWidth(),
			ival = 54,
			galState;
		
		$scope.articleLimit = function() {
			return pageSize * pagesShown;
		};
		$scope.hasMoreNewsToShow = function() {
				return pagesShown < ($scope.news.length / pageSize);
			};
		$scope.showMoreNews = function() {
			pagesShown = pagesShown + 1;
		};
		
		$('#sseGallery.news .item').addClass('list-group-item');
		
		if(iWW <= 1400){
			$(gw).css("width", iWW);
			$('.navbar.news .btn-group').css("right", ival);
		}
		
		$scope.list = function($event){
			var currEl = $event.currentTarget,
				txtContent = $('#sseGallery.news .item.list-group-item .gal-content'),
				txtTitle = $('#sseGallery.news .item.list-group-item .gal-name'),
				galWidth = $('#sseGallery.news .img-gallery').width(),
				contentWidth = galWidth - 290;
			galState = "list";
			$('.navbar.news .btn-group a').removeClass("selected");
			$(currEl).addClass("selected");
			$('#sseGallery.news .item').addClass('list-group-item');
			$('#sseGallery.news.editorial .item').addClass('editorial');
			$('#sseGallery.news .item .gal-name').addClass("notransition");
			setGalleryItemShadow();
			$(txtContent).css("width", contentWidth);
			$(txtTitle).css("width", contentWidth);
		};
		$scope.grid = function($event){
			var currEl = $event.currentTarget,
				txtContent = $('#sseGallery.news .item.list-group-item .gal-content'),
				txtTitle = $('#sseGallery.news .item.list-group-item .gal-name');
			galState = "grid";
			$('.navbar.news .btn-group a').removeClass("selected");
			$(currEl).addClass("selected");
			$('#sseGallery.news .item').removeClass('list-group-item');
			$('#sseGallery.news .item .gal-name').removeClass("notransition");
			setGalleryItemShadow();
			$(txtContent).css("width", "90%");
			$(txtTitle).css("width", "100%");
		};
		
		/*+++++++++++++++*/
		/* WINDOW RESIZE
		/*+++++++++++++++*/
		$(window).resize(function(){
			var winWidth = $(window).innerWidth(),
				itemWidth = $('#sseGallery.news .item .img-window').width(),
				val = ((winWidth - gwW)/2)+37,
				vc = $('#sseGallery.news .btn-group'),
				gwW = $(gw).width(),
				txtContent = $('#sseGallery.news .item.list-group-item .gal-content'),
				txtTitle = $('#sseGallery.news .item.list-group-item .gal-name'),
				pubTitle = $('#sseGallery.news .item.list-group-item .gal-pubdate'),
				contentWidth = gwW - 290,
				resizeTimer,
				lState = $('#sseGallery .btn-group #list'),
				gState = $('#sseGallery .btn-group #grid');
	
			if ($(lState).hasClass("selected")){
				galState = "list"
			} else {
				galState = "grid"
			}
			
			clearTimeout(resizeTimer);
			resizeTimer = setTimeout(function() {
				val = ((winWidth - 1400)/2)+37;
				if(winWidth <= 1400){
					gwW = $(gw).width();
					contentWidth = gwW - 290;
					$(gw).css("width", winWidth);
					checkGalState();
				} else {
					contentWidth = 1164;
					$(gw).css("width", "1400px");
					checkGalState();
				}
				if(winWidth <= 600){
					$('#sseGallery.news .btn-group').css("display", "none");
				} else {
					$('#sseGallery.news .btn-group').css("display", "inline-block");
				}
				if(galState == "list" && winWidth > 600){
					$('#sseGallery.news .item').addClass('list-group-item');
					$('#sseGallery.news.editorial .item').addClass('editorial');
					$('#sseGallery.news .item .gal-name').addClass("notransition");
					$(txtContent).css("width", contentWidth);
					$(txtTitle).css("width", contentWidth);
					setGalleryItemShadow();
				}
				if (winWidth > 1400  && $(this).scrollTop() > 135) {
					$(vc).css("right", val);
				} else {
					$(vc).css("right", "37px");
				};
			}, 0);
			
			if(winWidth <= 1400){
					$(gw).css("width", winWidth);
			}
				
			$('#sseGallery.news .item').find('.img-window').css("height", itemWidth);
			
			$('#sseGallery.news .item').find('.img-responsive').each(function(){
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
			
			if(galState == "list" && winWidth < 600){
				$('#sseGallery.news .item').removeClass('list-group-item');
				$('#sseGallery.news.editorial .item').removeClass('editorial');
				$('#sseGallery.news .item .gal-name').removeClass("notransition");
				$('#sseGallery.news .btn-group').css("display", "none");
				$(txtContent).css("width", "100%");
				$(txtTitle).css("width", "100%");
				setGalleryItemShadow();
			} else if(galState == "list" && winWidth > 600){
				$('#sseGallery.news .item').addClass('list-group-item');
				$('#sseGallery.news.editorial .item').addClass('editorial');
				$('#sseGallery.news .item .gal-name').addClass("notransition");
					$('#sseGallery.news .btn-group').css("display", "inline-block");
				$(txtContent).css("width", contentWidth);
				$(txtTitle).css("width", contentWidth);
				setGalleryItemShadow();
			}
			checkGalState();
		});
		
		/*+++++++++++++++++++*/
		/* WINDOW SCROLL CTRL
		/*++++++++++++++++++*/
		var viewCtrl = $('#sseGallery.news .btn-group'),
			listBtn = $('#sseGallery.news .btn-group #list'),
			gridBtn = $('#sseGallery.news .btn-group #grid');
		//Check initial scroll pos 
		if($(document).scrollTop() > 136){
			console.log("greater than 136");
			$(viewCtrl).css("position", "fixed");
			$(viewCtrl).css("top", "0");
			$(listBtn).css("border-top-left-radius", "0");
			$(gridBtn).css("border-top-right-radius", "0");
		} else {
			console.log("less than 136");
			$(viewCtrl).css("position", "absolute");
			$(viewCtrl).css("top", "30px");
			$(listBtn).css("border-top-left-radius", "7");
			$(gridBtn).css("border-top-right-radius", "7");
		};
		$(window).scroll(function(){
			setGalleryItemShadow();
			var WW = $(window).innerWidth(),
				g = $('#sseGallery').width(),
				val = ((WW - g)/2)+37;
				vc = $('#sseGallery.news .btn-group.fixedCtrl');
				$(vc).css("right", val);
			// News View Scroll Ctrl			
			$(document).on('scroll', function(){
					if($(this).scrollTop() > 136){
						$(viewCtrl).addClass("fixedCtrl");
						$(listBtn).css("border-top-left-radius", "0");
						$(gridBtn).css("border-top-right-radius", "0");
					} else {
						$(viewCtrl).removeClass("fixedCtrl");
						$(viewCtrl).css("position", "absolute");
						$(viewCtrl).css("top", "30px");
						$(vc).css("right", "37px");
						$(listBtn).css("border-top-left-radius", "7");
					$(gridBtn).css("border-top-right-radius", "7");
					};
			});
		});
	})
	.controller('FactoidsCarouselCtrl', function ($scope, sbFactory){
		sbFactory.get(function(data){
			$scope.slide = data;
		});	
		$scope.myInterval = 0;
		// $('#factoid-carousel').bind('slide.bs.carousel', function (e) {
			// alert("you made it here via bind");
		// };
	})
	.controller('galleriesCtrl', function ($scope, galleriesGalFactory){
		// HIDE "show less" buttons
		$('.gal-wrapper.best #less-wrapper').hide();
		$('.gal-wrapper.planets #less-wrapper').hide();
		$('.gal-wrapper.missions #less-wrapper').hide();		

		galleriesGalFactory.getBest().then(function(data){
			$scope.bestofgal = data.category_galleries;
			$scope.planetsgal = data.planet_galleries;
			$scope.missionsgal = data.mission_galleries;
			$scope.bestThumb = function(index){
				if ($scope.bestofgal[index].imagebrowse) {
					return data.category_galleries[index].imagebrowse;
				} else {
					return data.category_galleries[index].image;
				}
			};
			$scope.planetThumb = function(index){
				if ($scope.planetsgal[index].imagebrowse) {
					return data.planet_galleries[index].imagebrowse;
				} else {
					return data.planet_galleries[index].image;
				}
			};
			$scope.missionThumb = function(index){
				if ($scope.missionsgal[index].imagebrowse) {
					return data.mission_galleries[index].imagebrowse;
				} else {
					return data.mission_galleries[index].image;
				}
			};
			var bestPagesShown = 1,
				bestPageSize = 4,
				planetPagesShown = 1,
				planetPageSize = 4,
				missionPagesShown = 1,
				missionPageSize = 4;
			
			$scope.bestLimit = function() {
				return bestPageSize * bestPagesShown;
			};
			$scope.planetsLimit = function() {
				return planetPageSize * planetPagesShown;
			};
			$scope.missionsLimit = function() {
				return missionPageSize * missionPagesShown;
			};
			$scope.hasMoreBestToShow = function() {
				return bestPagesShown < ($scope.bestofgal.length / bestPageSize);
			};
			$scope.hasMorePlanetsToShow = function() {
				return planetPagesShown < ($scope.planetsgal.length / planetPageSize);
			};
			$scope.hasMoreMissionsToShow = function() {
				return missionPagesShown < ($scope.missionsgal.length / missionPageSize);
			};
			$scope.showMoreBest = function() {
				bestPagesShown = bestPagesShown + 4;
				$('.gal-wrapper.best #less-wrapper').addClass("visible");
				$('.gal-wrapper.best #less-wrapper').show();
			};
			$scope.showMorePlanets = function() {
				planetPagesShown = planetPagesShown + 4;
				$('.gal-wrapper.planets #less-wrapper').addClass("visible");
				$('.gal-wrapper.planets #less-wrapper').show();
			};
			$scope.showMoreMissions = function() {
				missionPagesShown = missionPagesShown + 4;
				$('.gal-wrapper.missions #less-wrapper').addClass("visible");
				$('.gal-wrapper.missions #less-wrapper').show();
			};
			$scope.showLessBest = function($event) {
				bestPagesShown = 1;
				$('.gal-wrapper.best #less-wrapper').removeClass("visible");
				$('.gal-wrapper.best #less-wrapper').hide();
				// var currChildren = $('#bestof-gallery').find('.item');
				// var childLength = $(currChildren).length;
				// if(childLength > 4){
					// bestPagesShown = bestPagesShown - 1;
				// }
			};
			$scope.showLessPlanets = function() {
				planetPagesShown = 1;
				$('.gal-wrapper.planets #less-wrapper').removeClass("visible");
				$('.gal-wrapper.planets #less-wrapper').hide();
			};
			$scope.showLessMissions = function() {
				missionPagesShown = 1;
				$('.gal-wrapper.missions #less-wrapper').removeClass("visible");
				$('.gal-wrapper.missions #less-wrapper').hide();
			};
			/*+++++++++++++++++++*/
			/* WINDOW SCROLL CTRL
			/*++++++++++++++++++*/
			$(window).scroll(function(){
				
				// Galleries Landing Page Scroll Ctrl
				var bestGal = $('.gal-wrapper.best'),
					planetsGal = $('.gal-wrapper.planets'),
					missionsGal = $('.gal-wrapper.missions'),
					bestLess = $('.gal-wrapper.best #less-wrapper.visible'),
					planetsLess = $('.gal-wrapper.planets #less-wrapper.visible'),
					missionsLess = $('.gal-wrapper.missions #less-wrapper.visible'),
					bestLessBtn = $('.gal-wrapper.best #less-wrapper.visible button'),
					planetsLessBtn = $('.gal-wrapper.planets #less-wrapper.visible button'),
					missionsLessBtn = $('.gal-wrapper.missions #less-wrapper.visible button');
					
				$(document).on('scroll', function(){
					var	bestLessOffset = $('.gal-wrapper.best #less-wrapper').offset().top,
						planetsLessOffset = $('.gal-wrapper.planets #less-wrapper').offset().top,
						missionsLessOffset = $('.gal-wrapper.missions #less-wrapper').offset().top,
						bestGalTop = $('.gal-wrapper.best').offset().top + 11,
						planetsGalTop = $('.gal-wrapper.planets').offset().top + 11,
						missionsGalTop = $('.gal-wrapper.missions').offset().top + 11,
						bestOffset = $(bestGal).offset().top,
						planetsOffset = $(planetsGal).offset().top,
						missionsOffset = $(missionsGal).offset().top,
						bestHeight = $(bestGal).height(),
						planetsHeight = $(planetsGal).height(),
						missionsHeight = $(missionsGal).height(),
						bestLessPos = bestGalTop - $(this).scrollTop(),
						planetsLessPos = planetsLessOffset - $(this).scrollTop(),
						missionsLessPos = missionsLessOffset - $(this).scrollTop(),
						bestGalBottom = (bestHeight + bestOffset) - $(this).scrollTop(),
						planetsGalBottom = (planetsHeight + planetsOffset) - $(this).scrollTop(),
						missionsGalBottom = (missionsHeight + missionsOffset) - $(this).scrollTop();
						
						
					if(bestGalBottom < 50 && $(bestLess).hasClass("visible")){
						$(bestLess).hide()
					} else if(bestGalBottom > 50 && $(bestLess).hasClass("visible")){
						$(bestLess).show();
					}
					if(planetsGalBottom < 50 && $(planetsLess).hasClass("visible")){
						$(planetsLess).hide()
					} else if(planetsGalBottom > 50 && $(planetsLess).hasClass("visible")){
						$(planetsLess).show();
					}
					if(bestLessPos < 0){
						$(bestLess).addClass("fixed");
						$(bestLessBtn).addClass("top-tab");
					}
					if(planetsLessPos < 0){
						$(planetsLess).addClass("fixed");
						$(planetsLessBtn).addClass("top-tab");
					}
					if(missionsLessPos < 0){
						$(missionsLess).addClass("fixed");
						$(missionsLessBtn).addClass("top-tab");
					}
					if($(this).scrollTop() < 217){
						$(bestLess).removeClass("fixed");
						$(bestLessBtn).removeClass("top-tab");
					}
					if(planetsLessPos < bestGalBottom){
						$(planetsLess).removeClass("fixed");
						$(planetsLessBtn).removeClass("top-tab");
					}
					if(missionsLessPos < planetsGalBottom){
						$(missionsLess).removeClass("fixed");
						$(missionsLessBtn).removeClass("top-tab");
					}
					
				});
			});
			/*+++++++++++++++*/
			/* WINDOW RESIZE
			/*+++++++++++++++*/
			$(window).resize(function(){
				var winWidth = $(window).innerWidth(),
					itemWidth = $('#sseGallery.galleries .item').width(),
					itemHeight = itemWidth*.69;
				if(winWidth < 1215){
					$('#sseGallery.galleries').find('.item').css("height", itemHeight);
					$('#sseGallery.galleries').find('.img-window').css("height", itemHeight);
					$('#sseGallery.galleries').find('a').css("height", itemHeight);
				} else {
					$('#sseGallery.galleries').find('.item').css("height", "224px");
					$('#sseGallery.galleries').find('.img-window').css("height", "224px");
					$('#sseGallery.galleries').find('a').css("height", "224px");
				}
				if(itemWidth > 333){
					var txtScale = itemWidth / 15;
					$('#sseGallery.galleries .gal-name').removeClass("f17");
					$('#sseGallery.galleries').find('.gal-name').css("font-size", txtScale);
				} else {
					$('#sseGallery.galleries .gal-name').addClass("f17");
				}
			});
		});	
	})
	.controller('galleriesDetailCtrl', function ($scope, page_data){
		// HIDE "show less" buttons
		$('.gal-wrapper.best #less-wrapper').hide();
		$('.gal-wrapper.planets #less-wrapper').hide();
		$('.gal-wrapper.missions #less-wrapper').hide();		
		var data = page_data.data;
		loadInteractivity();
			$scope.galCategory = data.title;
			$scope.gallery = data.gallery;
			$scope.galThumb = function(index){
				if ($scope.gallery[index].imagebrowse) {
					return data.gallery[index].imagebrowse;
				} else {
					return data.gallery[index].image;
				}
			};
			var galPagesShown = 1;
			var galPageSize = 20;
			$scope.currGalItem = 0;
			$scope.galLimit = function() {
				return galPageSize * galPagesShown;
			};
			$scope.hasMoreGalToShow = function() {
				return galPagesShown < ($scope.gallery.length / galPageSize);
			};
			$scope.showMoreGal = function() {
				galPagesShown = galPagesShown + 4;
				$('.gal-wrapper.gal #less-wrapper').addClass("visible");
				$('.gal-wrapper.gal #less-wrapper').show();
			};
			$scope.showLessGal = function($event) {
				galPagesShown = 1;
				$('.gal-wrapper.gal #less-wrapper').removeClass("visible");
				$('.gal-wrapper.gal #less-wrapper').hide();
			};
			$scope.galView = function($event){
				var e = $event.currentTarget,
					i = $(e).parent().html();
					id = $(e).attr("data-id");
					$scope.currGalItem = id;
					console.log(i);
				
			}
			/*+++++++++++++++++++*/
			/* WINDOW SCROLL CTRL
			/*++++++++++++++++++*/
			$(window).scroll(function(){
				
				// Galleries Landing Page Scroll Ctrl
				var gal = $('.gal-wrapper.gal'),
					galLess = $('.gal-wrapper.gal #less-wrapper.visible'),
					galLessBtn = $('.gal-wrapper.gal #less-wrapper.visible button');
					
				$(document).on('scroll', function(){
					var	galLessOffset = $('.gal-wrapper.gal #less-wrapper').offset().top,
						galTop = $('.gal-wrapper.gal').offset().top + 11,
						galOffset = $(gal).offset().top,
						galHeight = $(gal).height(),
						galLessPos = galTop - $(this).scrollTop(),
						galBottom = (galHeight + galOffset) - $(this).scrollTop();
						
						
					if(galBottom < 50 && $(galLess).hasClass("visible")){
						$(galLess).hide()
					} else if(galBottom > 50 && $(galLess).hasClass("visible")){
						$(galLess).show();
					}
					if(galLessPos < 0){
						$(galLess).addClass("fixed");
						$(galLessBtn).addClass("top-tab");
					}
					if($(this).scrollTop() < 217){
						$(galLess).removeClass("fixed");
						$(galLessBtn).removeClass("top-tab");
					}					
				});
			});
			/*+++++++++++++++*/
			/* WINDOW RESIZE
			/*+++++++++++++++*/
			$(window).resize(function(){
				var winWidth = $(window).innerWidth(),
					itemWidth = $('#sseGallery.galleries .item').width(),
					itemHeight = itemWidth*.69;
				if(winWidth < 1215){
					$('#sseGallery.galleries').find('.item').css("height", itemHeight);
					$('#sseGallery.galleries').find('.img-window').css("height", itemHeight);
					$('#sseGallery.galleries').find('a').css("height", itemHeight);
				} else {
					$('#sseGallery.galleries').find('.item').css("height", "224px");
					$('#sseGallery.galleries').find('.img-window').css("height", "224px");
					$('#sseGallery.galleries').find('a').css("height", "224px");
				}
				if(itemWidth > 333){
					var txtScale = itemWidth / 15;
					$('#sseGallery.galleries .gal-name').removeClass("f17");
					$('#sseGallery.galleries').find('.gal-name').css("font-size", txtScale);
				} else {
					$('#sseGallery.galleries .gal-name').addClass("f17");
				}
			});
	});