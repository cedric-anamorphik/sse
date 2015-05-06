'use strict';

angular.module('pageController',['ngResource','appDataFactory'])
  .controller('pageController', ['$scope','_','page_data','$state','appDataFactory','$controller',
    function($scope, _, page_data, $state, appDataFactory, $controller){
      $scope.page = {};
      $scope.page.hasSidebar = false;
      $scope.page.css = {};
      $scope.page.css.content = ['col-8','col-md-8','col-sm-12','col-xs-12','content','table-col'];
      $scope.page.css.sidebar = ['col-4','col-md-4','col-sm-12','col-xs-12','table-col'];
      //$scope.page.css.wrapper = $state.current.data.wrapper_css;
      $scope.page.css.wrapper = ['container','table','page'];

      if(page_data.data.contenttype == 'page') {
        $scope.page.css.wrapper.push('basic');
      } else {
        $scope.page.css.wrapper.push(page_data.data.contenttype);
      }
      if(_.indexOf(['missions','planets'],page_data.data.contenttype,true) >= 0 && page_data.data.path.length >= 3) {
        $scope.page.css.content.push('detail');
      }
      //inject list controller as needed
      /*if(page_data.data.view == 'list' && page_data.data.contenttype == 'news') {
        //$controller('NewsListCtrl', { $scope: NewsListCtrl });
      }*/
      $scope.widgets = {};
      $scope.widgets.learningFocusIndex = { value: 0 };
      $scope.page.featured_image = {};
      $scope.page.featured_image.show = false;
      $scope.page.prefix = page_data.data.contenttype;

      $scope.page.data = appDataFactory.processData(page_data.data);
      $scope.page.data = page_data.data;
      if(_.has($scope.page.data.sidebar,'subnav') && _.isEmpty($scope.page.data.sidebar.subnav)) { delete $scope.page.data.sidebar['subnav']; }
      $scope.page.hasSidebar = !_.isEmpty($scope.page.data.sidebar);

      if(!$scope.page.hasSidebar) {
        $scope.page.css.content = _.remove($scope.page.css.content, function(css) { return css.indexOf("-8") < 0; });
      }
      if(_.has($scope.page.data.main,'images') && $scope.page.data.main.images.length > 0) {
        var image = $scope.page.data.main.images[0];
        if(image.align == 'center') {
          $scope.page.featured_image = image;
          $scope.page.featured_image.show = true;
        }
      }

  }]);
