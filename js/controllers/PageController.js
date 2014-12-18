'use strict';

angular.module('pageController',['ngResource','appDataFactory'])
  .controller('pageController', ['$scope','_','page_data','appDataFactory',
    function($scope, _, page_data, appDataFactory){
      $scope.page = {};
      $scope.page.css = {};
      $scope.page.css.content = ['col-sm-8','col-xs-12','content'];
      $scope.page.css.sidebar = ['col-sm-4','col-xs-12'];
      $scope.widgets = {};
      $scope.widgets.learningFocusIndex = { value: 0 };
      $scope.page.featured_image = {};
      $scope.page.featured_image.show = false;

      $scope.page.data = appDataFactory.processData(page_data.data);
      $scope.page.hasSidebar = !_.isEmpty($scope.page.data.sidebar);

      if(!$scope.page.hasSidebar) {
        $scope.page.css.content = _.remove($scope.page.css.content, function(css) { return css != 'col-sm-8'; });
      }
      if(_.has($scope.page.data.main,'images') && $scope.page.data.main.images.length > 0) {
        var image = $scope.page.data.main.images[0];
        if(image.align == 'center') {
          $scope.page.featured_image = image;
          $scope.page.featured_image.show = true;
        }
      }

  }]);
