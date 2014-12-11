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

      appDataFactory.loadData().then(function(page_data) {
        /*console.log(page_data.sidebar);
        if(typeof page_data.sidebar.learn != 'undefined') {
          console.log('learning focus loadData');
          scope.focused = page_data.sidebar.learn;
          console.log(scope.focused);
        }*/
        if(_.has(page_data.sidebar,'learn') && page_data.sidebar.learn.length > 0) {
          scope.widgets.learning_focus.data = page_data.sidebar.learn;
          console.log('scope.widgets.learning_focus.data');
          console.log(scope.widgets.learning_focus.data);
          if(scope.widgets.learning_focus.data[scope.widgets.learningFocusIndex.value].related_missions[0].missions.length < 1) {
            scope.widgets.learning_focus.container.classes.push('no-bottom');
          }

/*          if(scope.widgets.learning_focus.featured.related_missions[0].missions.length < 1) {
            scope.widgets.learning_focus.container.classes.push('no-bottom');
          }*/
        }
      });

      scope.widgets.learning_focus.fn.onAfterChange = function() {
        //console.log($('#slick_learningFocus').slickCurrentSlide());
        scope.widgets.learningFocusIndex.value = $('#slick_learningFocus').slickCurrentSlide();
        console.log(scope.widgets.learning_focus.data[scope.widgets.learningFocusIndex.value]);
        if(scope.widgets.learning_focus.data[scope.widgets.learningFocusIndex.value].related_missions[0].missions.length < 1) {
          scope.widgets.learning_focus.container.classes.push('no-bottom');
        }
        scope.$apply();
      }

/*      scope.widgets.learning_focus.fn.getIndex = function() {
        console.log($('#slick_relatedFocus').slickCurrentSlide());
      }*/

/*      scope.widgets.learning_focus.fn.goPrev = function() {
        var index = scope.learningFocusIndex - 1;
        if(index < 0) index = scope.widgets.learning_focus.data.length - 1;
        console.log('go prev index: ' + index);
        scope.widgets.learning_focus.featured = scope.widgets.learning_focus.data[index];
        scope.learningFocusIndex = index;
      }

      scope.widgets.learning_focus.fn.goNext = function() {
        var index = scope.learningFocusIndex + 1;
        if(index > scope.widgets.learning_focus.data.length - 1) index = 0;
        console.log('go next index: ' + index);
        scope.widgets.learning_focus.featured = scope.widgets.learning_focus.data[index];
        scope.learningFocusIndex = index;
      }*/
    }
  }
}]);
