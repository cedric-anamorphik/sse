// MAIN SSE APP
// PLEASE BE RESPONSIBLE AND REMEMBER TO INSERT YOUR NEW DEPENDENCIES HERE
var app = angular.module('sse', ['ui.router', 'uiRouterStyles', 'sse.directives', 'timer', 'slick', 'sse.controllers', 'appDataFactory', 'pageController', 'ngSanitize', 'lodash', 'ui.bootstrap', 'ngAnimate', 'truncate', 'mbExtruder', 'pageslide-directive']);

// STATES are for loading content in a page when it loads based on the url
app.config(function($stateProvider, $urlRouterProvider, $locationProvider) {
	$urlRouterProvider.otherwise('/cmspage');
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
			views: {
			  'main': {
			    templateUrl:'includes/partial-educationLanding.html',
			    controller: 'pageController'
			  }
			}
			/*templateUrl: 'includes/partial-educationLanding.html',
			controller: 'pageController'*/
		})
		.state('galleries', {
			url: '/galleries/',
			views: {
				'main': {
					templateUrl: 'includes/partial-galleriesLanding.html'
				}
			}
			/*templateUrl: 'includes/partial-galleriesLanding.html'*/
		})
		.state('galleriesdetail', {
			url: '/galleries/:galleries_sub/:galleries_id',
			views: {
				'main': {
					templateUrl: 'includes/partial-galleries-l2.html',
					controller: 'galleriesDetailCtrl'
				}
			},
			/*templateUrl: 'includes/partial-galleries-l2.html',*/
			resolve: {
				appDataFactory: 'appDataFactory',
				page_data: ['appDataFactory','$stateParams', function(appDataFactory,$stateParams) {
					return appDataFactory.queryData('galleries',$stateParams);
				}]
			}
			/*controller: 'galleriesCtrl'*/
		})
		.state('missionLanding',{
			url: '/missions/',
			views: {
				'main': { templateUrl:'includes/partial-missionsLanding.html' }
			}
		})
		.state('missionType',{
			url: '/missions/type',
			views: {
				'main': { templateUrl:'includes/partial-missionsType.html' }
			}
		})
		.state('missionTarget',{
			url: '/missions/target',
			views: {
				'main': { templateUrl:'includes/partial-missionsTarget.html' }
			}
		})
		.state('missionsDetail', {
			url: '/missions/:missions_sub/:missions_id',
			views: {
				'main': {
					templateUrl: 'includes/partial-missions-details.html',
					controller: 'missionsDetailCtrl'
				}
			},
			/*templateUrl: 'includes/partial-galleries-l2.html',*/
			resolve: {
				appDataFactory: 'appDataFactory',
				page_data: ['appDataFactory','$stateParams', function(appDataFactory,$stateParams) {
					return appDataFactory.queryData('missions',$stateParams);
				}]
			}
			/*controller: 'galleriesCtrl'*/
		})
		.state('newsLanding', {
			url: '/news/',
			views: {
				'main': { templateUrl: 'includes/partial-newsLanding.html' }
			}
		})
		.state('people',{
			url: '/people/',
			views: {
			  'main': { templateUrl:'includes/partial-peopleLanding.html' }
			}
		})
		.state('planets',{
			url: '/planets/',
			views: {
				'main': { templateUrl:'includes/partial-planetsLanding.html' }
			}
		})
		.state('cmspage', {
			url: '*path',
			views: {
				'main': {
					templateUrl: 'includes/partial-page.html',
					controller: 'pageController'
				},
				'detail-content@cmspage': {
					templateProvider: ['$stateParams','appDataFactory','$templateFactory',function($stateParams, appDataFactory, $templateFactory) {
						return appDataFactory.queryData('cmspage',$stateParams).then(function(data) {
							return $templateFactory.fromUrl(appDataFactory.queryTemplate('content',data.data));
						}).then(function(response) {
							return response;
						});
					}]
				},
				'sidebar-right@cmspage': {
					templateProvider: ['$stateParams','appDataFactory','$templateFactory',function($stateParams, appDataFactory, $templateFactory) {
						return appDataFactory.queryData('cmspage',$stateParams).then(function(data) {
							return $templateFactory.fromUrl(appDataFactory.queryTemplate('sidebar',data.data));
						}).then(function(response) {
							return response;
						});
					}]
				}
			},
			resolve: {
				appDataFactory: 'appDataFactory',
				page_data: ['appDataFactory','$stateParams', function(appDataFactory,$stateParams) {
					return appDataFactory.queryData('cmspage',$stateParams);
				}]
			},
			data: {
				css: 'css/planets-missions-background.css'
			}
		})
		.state('404', {
			url: '/404',
			templateUrl: 'includes/partial-404.html'
		});

    // $locationProvider.html5Mode(true);
}).run(['$rootScope','$state', '$stateParams', '$location', 'appDataFactory',
	function($rootScope, $state, $stateParams, $location, appDataFactory) {
		var state = 'home', path = $location.path(), data = {};

		if(path == "/" || path == "") {
			$state.transitionTo('home');
		}

		$rootScope.$on('$stateChangeError',function(event, toState, toParams, fromState, fromParams, error) {
			//$state.transitionTo('404');
		});
	}]);
