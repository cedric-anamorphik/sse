'use strict';

angular.module('mbExtruder',[]).directive('mbExtruder',[function() {
  return {
    restrict: 'AE',
    transclude: true,
    template: '<div ng-transclude></div>',
    replace: false,
    compile: function(tElement, tAttrs) {
      console.log(tAttrs);
      $(tElement).buildMbExtruder({
        position: tAttrs.position ? tAttrs.position : "right",
        width: tAttrs.width ? tAttrs.width : 300,
        extruderOpacity: tAttrs.extruderOpacity ? tAttrs.extruderOpacity : 0.8,
        textOrientation: tAttrs.textOrientation ? tAttrs.textOrientation : "tb"
      });
      /*return {
        post: function postLink(scope, element, attrs) {
          $(element).buildMbExtruder({
            position: "right",
            width: 300,
            extruderOpacity: 0.8,
            textOrientation: "tb"
          });
        }
      };*/
    }
  };
}]);
