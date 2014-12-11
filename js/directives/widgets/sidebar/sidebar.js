// Create an array for feed list
var feeds = [];

angular.module('sse.directives', ['ngResource'])
	.factory('FeedLoader', function ($resource) {
        return $resource('http://ajax.googleapis.com/ajax/services/feed/load', {}, {
            fetch: { method: 'JSONP', params: {v: '1.0', callback: 'JSONP_CALLBACK'} }
        });
    })
    .service('FeedList', function ($rootScope, FeedLoader) {
        this.jsonp = function() {
            var feedSources = [{title: 'Slashdot', url: 'http://rss.slashdot.org/Slashdot/slashdot'}];
            if (feeds.length === 0) {
                for (var i=0; i<feedSources.length; i++) {
                    FeedLoader.fetch({q: feedSources[i].url, num: 10}, {}, function (data) {
                        var feed = data.responseData.feed;
                        feeds.push(feed);
                    });
                }
            }
            return feeds;
        };
    })
	// LOAD Factoid 1
	.directive('factoid1', function () {
		return {
		  restrict: 'E',
		  templateUrl: 'includes/factoid1.html'
		 }
	})
	// LOAD Factoid 2
	.directive('factoid2', function () {
		return {
		  restrict: 'E',
		  templateUrl: 'includes/factoid2.html'
		 }
	})
	// LOAD Factoid 3
	.directive('factoid3', function () {
		return {
		  restrict: 'E',
		  templateUrl: 'includes/factoid3.html'
		 }
	})
	// LOAD Popular Planets
	.directive('popplanets', function () {
		return {
		  restrict: 'E',
		  templateUrl: 'includes/popPlanets.html'
		 }
	})
	// LOAD Popular Missions
	.directive('popmissions', function () {
		return {
		  restrict: 'E',
		  templateUrl: 'includes/popMissions.html'
		 }
	})
	// LOAD Popular Images
	.directive('popimages', function () {
		return {
		  restrict: 'E',
		  templateUrl: 'includes/popImages.html'
		 }
	})
	// LOAD Popular Downloads
	.directive('popdownloads', function () {
		return {
		  restrict: 'E',
		  templateUrl: 'includes/popDownloads.html'
		 }
	})
	// INIT factoid frames
	.directive("async", function( $timeout ) {
		function link( $scope, element, attributes ) {
		var watch = $scope.$watch(function() {
			return element.children().length;
			}, function() {
				$scope.$evalAsync(
					function( $scope ) {
							$rbox = $('#rbox-wrapper'),
							$rhdrL = $('.rbox-header-left');
							$('.rbox-header-right').width($rbox.width() - $rhdrL.width()-25);
					}
				);
			});
		}
		// Return the configuration.
		return({
			link: link
		});
	})
	.directive("async2", function( $timeout ) {
		function link( $scope, element, attributes ) {
		var watch = $scope.$watch(function() {
			return element.children().length;
			}, function() {
				$scope.$evalAsync(
					function( $scope ) {
							// Highlight current profile
							$('#slick-people>div>.slick-track>div.slick-active:nth(1)>p.profile-name').css("color", "#fff");
							$('#slick-people>div>.slick-track>div.slick-active:nth(1)>p.profile-title').css("color", "#fff");
							$('#slick-people>button.slick-next').bind("click", function(){
								$('#slick-people>div>.slick-track>div.slick-active:nth(0)>p.profile-name').css("color", "#452f4a");
								$('#slick-people>div>.slick-track>div.slick-active:nth(0)>p.profile-title').css("color", "#452f4a");
								$('#slick-people>div>.slick-track>div.slick-active:nth(1)>p.profile-name').css("color", "#fff");
								$('#slick-people>div>.slick-track>div.slick-active:nth(1)>p.profile-title').css("color", "#fff");
								$('#slick-people>div>.slick-track>div.slick-active:nth(2)>p.profile-name').css("color", "#452f4a");
								$('#slick-people>div>.slick-track>div.slick-active:nth(2)>p.profile-title').css("color", "#452f4a");
							});
							$('#slick-people>button.slick-prev').bind("click", function(){
								$('#slick-people>div>.slick-track>div.slick-active:nth(0)>p.profile-name').css("color", "#452f4a");
								$('#slick-people>div>.slick-track>div.slick-active:nth(0)>p.profile-title').css("color", "#452f4a");
								$('#slick-people>div>.slick-track>div.slick-active:nth(1)>p.profile-name').css("color", "#fff");
								$('#slick-people>div>.slick-track>div.slick-active:nth(1)>p.profile-title').css("color", "#fff");
								$('#slick-people>div>.slick-track>div.slick-active:nth(2)>p.profile-name').css("color", "#452f4a");
								$('#slick-people>div>.slick-track>div.slick-active:nth(2)>p.profile-title').css("color", "#452f4a");
							});	
					}
				);
			});
		}
		// Return the configuration.
		return({
			link: link
		});
	});