// MAIN SSE APP
// PLEASE BE RESPONSIBLE AND REMEMBER TO INSERT YOUR NEW DEPENDENCIES HERE
var app = angular.module('sse', ['ui.router', 'uiRouterStyles', 'sse.directives', 'timer', 'slick', 'sse.controllers', 'appDataFactory', 'pageController', 'ngSanitize', 'lodash', 'ui.bootstrap', 'ngAnimate', 'truncate']);

// STATES are for loading content in a page when it loads based on the url
app.config(function($stateProvider, $urlRouterProvider, $locationProvider) {
	//$urlRouterProvider.otherwise('ray/sse/');
	//TODO: relative paths
	$stateProvider
		// HOME STATES AND NESTED VIEWS
		.state('home', {
			url: '/',
			views: {
				'content': {
					templateUrl: 'includes/partial-home-content.html'
				},
				'sidebar-first':{
					templateUrl: 'includes/partial-sidebar.html'
				}
			},
			data: {css: 'css/home.css'}
		})
		.state('educ', {
			url: '/educ/',
			templateUrl: 'includes/partial-educationLanding.html',
			controller: 'pageController'
		})
		.state('galleries', {
			url: '/galleries/',
			templateUrl: 'includes/partial-galleriesLanding.html'
		})
		.state('missionLanding',{
			url: '/missions/',
			templateUrl:'includes/partial-missionsLanding.html'
		})
		.state('missionType',{
			url: '/missions/type',
			templateUrl:'includes/partial-missionsType.html'
		})
		.state('missionTarget',{
			url: '/missions/target',
			templateUrl:'includes/partial-missionsTarget.html'
		})
		.state('newsLanding', {
			url: '/news/',
			templateUrl: 'includes/partial-newsLanding.html'
		})
		.state('people',{
			url: '/people/',
			templateUrl:'includes/partial-peopleLanding.html'
		})
		.state('planets',{
			url: '/planets/',
			templateUrl:'includes/partial-planetsLanding.html'
		})
		.state('planetsdetail', {
			url: '/planets/:planet_id',
			templateUrl: 'includes/partial-planet-detail.html',
			resolve: {
				page_data: ['appDataFactory','$stateParams', function(appDataFactory,$stateParams) {
					return appDataFactory.queryData('planets',$stateParams);
				}]
			},
			controller: 'pageController'
		})
		.state('planetsdetailsub', {
			url: '/planets/:planet_id/:sub_id',
			templateUrl: 'includes/partial-planet-detail.html',
			resolve: {
				appDataFactory: 'appDataFactory',
				page_data: ['appDataFactory','$stateParams', function(appDataFactory,$stateParams) {
					return appDataFactory.queryData('planets',$stateParams);
				}]
			},
			controller: 'pageController'
		})
		.state('missionsdetail', {
			url: '/missions/:mission_id',
			templateUrl: 'includes/partial-missions-detail.html',
			resolve: {
				appDataFactory: 'appDataFactory',
				page_data: ['appDataFactory','$stateParams', function(appDataFactory,$stateParams) {
					return appDataFactory.queryData('missions',$stateParams);
				}]
			},
			controller: 'pageController'
		})
		.state('newsdetail', {
			url: '/news/:news_year/:news_month/:news_day/:news_title',
			templateUrl: 'includes/partial-page.html',
			resolve: {
				appDataFactory: 'appDataFactory',
				page_data: ['appDataFactory','$stateParams', function(appDataFactory,$stateParams) {
					return appDataFactory.queryData('news',$stateParams);
				}]
			},
			controller: 'pageController'
		})
		.state('peopledetail', {
			url: '/people/:person_name',
			templateUrl: 'includes/partial-people-detail.html',
			resolve: {
				appDataFactory: 'appDataFactory',
				page_data: ['appDataFactory','$stateParams', function(appDataFactory,$stateParams) {
					return appDataFactory.queryData('people',$stateParams);
				}]
			},
			controller: 'pageController'
		})
		.state('educdetail', {
			url: '/educ/:page_id',
			templateUrl: 'includes/partial-page.html',
			resolve: {
				appDataFactory: 'appDataFactory',
				page_data: ['appDataFactory','$stateParams', function(appDataFactory,$stateParams) {
					return appDataFactory.queryData('educ',$stateParams);
				}]
			},
			controller: 'pageController'
		})
		.state('404', {
			url: '/404',
			templateUrl: 'includes/partial-404.html'
		});

    // $locationProvider.html5Mode(true);
}).run(['$state', '$stateParams', '$location', 'appDataFactory',
	function($state, $stateParams, $location, appDataFactory) {
		var state = 'home', path = $location.path(), data = {};

		if(path == "/" || path == "") {
			$state.transitionTo('home');
		}
	}]);
