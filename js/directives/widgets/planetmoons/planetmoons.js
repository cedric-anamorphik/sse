'use strict';

app.directive('planetMoons', ['appDataFactory','_',function(appDataFactory,_) {
    return {
      restrict: 'E',
      templateUrl: "js/directives/widgets/planetmoons/planetmoons.html",
      replace: true,
      link: function(scope, elem, attrs) {
        scope.widgets.planetmoons = {};
        scope.widgets.planetmoons.data = {};
        scope.widgets.planetmoons.show_widget = false;
        if(_.has(scope.page.data,'moonscontent') && _.has(scope.page.data,'moonsurl')) {
          scope.widgets.planetmoons.data.url = scope.page.data.moonsurl;
          scope.widgets.planetmoons.data.moonscontent = scope.page.data.moonscontent;
          scope.widgets.planetmoons.show_widget = true;
        }
      }
    }
  }]);
