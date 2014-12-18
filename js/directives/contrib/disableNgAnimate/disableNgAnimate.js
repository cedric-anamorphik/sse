/**
 * solution provided by whitehat101, https://github.com/angular-ui/bootstrap/issues/1350
 */

'use strict';

app.directive('disableNgAnimate', ['$animate', function($animate) {
  return {
    restrict: 'A',
    link: function(scope, element) {
      $animate.enabled(false, element);
    }
  };
}]);
