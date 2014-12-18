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
		$scope.peopleLimit = function() {
			return pageSize * pagesShown;
		};
		$scope.hasMorePeopleToShow = function() {
			return pagesShown < ($scope.people.length / pageSize);
		};
		$scope.showMorePeople = function() {
			pagesShown = pagesShown + 1;         
		};
	})
	.controller('NewsGalCtrl', function($scope, newsGalFactory){
		newsGalFactory.getNews().then(function(data){
			$scope.news = data.news;
		});		
		
		var pagesShown = 1;
		var pageSize = 8;
		$scope.articleLimit = function() {
			return pageSize * pagesShown;
		};
		$scope.hasMoreNewsToShow = function() {
			return pagesShown < ($scope.news.length / pageSize);
		};
		$scope.showMoreNews = function() {
			pagesShown = pagesShown + 1;
			// var currSel = $('#sseGallery.news').find('a.selected'),
			// currType = $(currSel).attr("id");
			// if(currType == "list"){
				// var target = $('#news-gallery').find('.item');
				// console.log($(target));
				// $(target).addClass('list-group-item');
			// };			
		};
		$scope.list = function($event){
			var currEl = $event.currentTarget;
			$('.navbar.news .btn-group a').removeClass("selected");
			$(currEl).addClass("selected");
			$('#news-gallery .item').addClass('list-group-item');
			$('#news-gallery .item .gal-name').addClass("notransition");
		};
		$scope.grid = function($event){
			var currEl = $event.currentTarget;
			$('.navbar.news .btn-group a').removeClass("selected");
			$(currEl).addClass("selected");
			$('#news-gallery .item').removeClass('list-group-item');
			$('#news-gallery .item .gal-name').removeClass("notransition");
		};
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
		galleriesGalFactory.getBest().then(function(data){
			$scope.bestofgal = data.category_galleries;
			$scope.bestThumb = {};
			$scope.planetgal = data.planets_galleries;
			$scope.missiongal = data.mission_galleries;
			if ($scope.bestofgal[0].image == '') {
				$scope.bestThumb = data.category_galleries[0].image;
			} else {
				$scope.bestThumb = data.category_galleries[0].imagebrowse;
			}
		});		
		
		var pagesShown = 1;
		var pageSize = 4;
		$scope.bestLimit = function() {
			return pageSize * pagesShown;
		};
		$scope.hasMorBestToShow = function() {
			return pagesShown < ($scope.people.length / pageSize);
		};
		$scope.showMoreBest = function() {
			pagesShown = pagesShown + 1;         
		};
	});