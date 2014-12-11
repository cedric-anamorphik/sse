'use strict';

angular.module('pageController',['ngResource','appDataFactory'])
  .controller('pageController', ['$scope','$resource','$location','page_data','_','$timeout',
    function($scope, $resource, $location, page_data, _,$timeout){
      $scope.page = {};
      $scope.page.css = {};
      $scope.page.css.content = ['col-sm-8','col-xs-12','content'];
      $scope.page.css.sidebar = ['col-sm-4','col-xs-12'];
      $scope.widgets = {};
      $scope.widgets.learningFocusIndex = { value: 0 };
      $scope.init = function() {
        $scope.page.data = page_data;
        $scope.page.hasSidebar = !_.isEmpty($scope.page.data.sidebar);
        console.log('empty sidebar');
        console.log(_.isEmpty($scope.page.data.sidebar));
        if(!$scope.page.hasSidebar) {
          $scope.page.css.content = _.remove($scope.page.css.content, function(css) { return css != 'col-sm-8'; });
        }
      }

      $scope.init();

    //console.log(factory_data);
    //$scope.data = factory_data;
  }]);
