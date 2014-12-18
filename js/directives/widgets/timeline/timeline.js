'use strict';

app.directive('timeline', ['appDataFactory',function(appDataFactory) {
    return {
      restrict: 'E',
      templateUrl: "js/directives/widgets/timeline/timeline.html",
      replace: true,
      link: function(scope, elem, attrs) {
        scope.widgets.timeline = {};
        scope.widgets.timeline.data = [];
        scope.widgets.timeline.selected = {};
        scope.widgets.timeline.fn = {};
        scope.widgets.timeline.starting_index = 0;

        if(_.has(scope.page.data, 'timeline') && scope.page.data.timeline.length > 0) {
          scope.widgets.timeline.data = scope.page.data.timeline;
          _.forEach(scope.widgets.timeline.data, function(item) {
            item.classes = ['item'];
          });
          scope.widgets.timeline.data[scope.widgets.timeline.starting_index].classes.push('featured');
          scope.widgets.timeline.selected = scope.widgets.timeline.data[scope.widgets.timeline.starting_index];
        }

        scope.widgets.timeline.fn.is_featured = function(index) {
          var currentIndex = $('#slick_timeline').slickCurrentSlide();
          if(index == currentIndex) return 'featured';
        }

        scope.widgets.timeline.fn.set_slide = function() {
          $('#slick_timeline').slickCurrentSlide()
        }

        scope.widgets.timeline.fn.set_featured = function() {
          _.forEach(scope.widgets.timeline.data, function(item) {
            _.remove(item.classes,function(css) { return css == 'featured'; });
          });
          console.log($('#slick_timeline').slickCurrentSlide());
          scope.widgets.timeline.data[$('#slick_timeline').slickCurrentSlide()].classes.push('featured');
          scope.widgets.timeline.selected = scope.widgets.timeline.data[$('#slick_timeline').slickCurrentSlide()];
          scope.$apply();
        }

        scope.widgets.timeline.fn.item_classes = function(index) {
          return scope.widgets.timeline.data[index].classes;
        }
      }
    }
  }]);
