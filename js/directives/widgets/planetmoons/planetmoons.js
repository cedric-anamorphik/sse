'use strict';

app.directive('planetMoons', ['appDataFactory','_',function(appDataFactory,_) {
    return {
      restrict: 'E',
      templateUrl: "js/directives/widgets/planetmoons/planetmoons.html",
      replace: true,
      link: function(scope, elem, attrs) {
        scope.widgets.planetmoons = {};
        scope.widgets.planetmoons.data = {};
        if(_.has(scope.page.data,'moonsblurb') && _.has(scope.page.data,'moonsurl')) {
          scope.widgets.planetmoons.data.url = scope.page.data.moonsurl;
          scope.widgets.planetmoons.data.blurb = scope.page.data.moonsblurb;
        }
      }
    }
  }]);
