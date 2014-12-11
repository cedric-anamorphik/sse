'use strict';

app.directive('creditsInfo', ['appDataFactory',function(appDataFactory) {
    return {
      restrict: 'E',
      templateUrl: "js/directives/widgets/credits_info/credits_info.html",
      replace: true,
      link: function(scope, elem, attrs) {
        scope.widgets.credit_info = {};
        scope.widgets.credit_info.data = {};
        scope.widgets.credit_info.show_widget = false;
        appDataFactory.loadData().then(function(page_data) {
/*          if(typeof page_data.sidebar.missions != 'undefined') {
            scope.missions = page_data.sidebar.missions;
          }*/
          if(_.has(page_data, 'credits')) {
            scope.widgets.credit_info.data = page_data.credits;
            _.forOwn(scope.widgets.credit_info.data, function(item) { if(item != '')  scope.show_widget = true; } );
          }
        });
      }
    }
  }]);
