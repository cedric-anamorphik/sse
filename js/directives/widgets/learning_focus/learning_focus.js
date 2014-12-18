'use strict';

app.directive('learningFocus', ['appDataFactory', function(appDataFactory) {
  return {
    restrict: "E",
    templateUrl: "js/directives/widgets/learning_focus/learning_focus.html",
    replace: true,
    link: function(scope, elem, attrs) {
      scope.widgets.learning_focus = {};
      scope.widgets.learning_focus.data = [];
      scope.widgets.learning_focus.fn = {};
      scope.widgets.learning_focus.container = {};
      scope.widgets.learning_focus.container.classes = ['widgets'];

      if(_.has(scope.page.data.sidebar,'learn') && scope.page.data.sidebar.learn.length > 0) {
        scope.widgets.learning_focus.data = scope.page.data.sidebar.learn;
        if(scope.widgets.learning_focus.data[scope.widgets.learningFocusIndex.value].related_missions[0].missions.length < 1) {
          scope.widgets.learning_focus.container.classes.push('no-bottom');
        }
      }

      scope.widgets.learning_focus.fn.onAfterChange = function() {
        //console.log($('#slick_learningFocus').slickCurrentSlide());
        scope.widgets.learningFocusIndex.value = $('#slick_learningFocus').slickCurrentSlide();
        console.log(scope.widgets.learning_focus.data[scope.widgets.learningFocusIndex.value]);
        if(scope.widgets.learning_focus.data[scope.widgets.learningFocusIndex.value].related_missions[0].missions.length < 1) {
          scope.widgets.learning_focus.container.classes.push('no-bottom');
        }
        scope.$apply();
      }

    }
  }
}]);
