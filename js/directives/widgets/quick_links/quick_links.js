'use strict';

app.directive('quickLinks', ['appDataFactory','_',function(appDataFactory,_) {
    return {
      restrict: 'E',
      templateUrl: "js/directives/widgets/quick_links/quick_links.html",
      replace: true,
      link: function(scope, elem, attrs) {
        scope.widgets.quick_links = {};
        scope.widgets.quick_links.data = [];
        if(_.has(scope.page.data,'quick_links') && scope.page.data.quick_links.length > 0) {
          scope.widgets.quick_links.data = scope.page.data.quick_links;
        }
      }
    }
  }]);
