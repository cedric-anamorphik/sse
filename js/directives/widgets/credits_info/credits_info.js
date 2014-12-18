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

        if(_.has(scope.page.data, 'credits')) {
          scope.widgets.credit_info.data = scope.page.data.credits;
          _.forOwn(scope.widgets.credit_info.data, function(item) { if(item != '')  scope.show_widget = true; } );
        }

      }
    }
  }]);
