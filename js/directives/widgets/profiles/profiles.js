'use strict';

app.directive('profiles', ['appDataFactory',function(appDataFactory) {
    return {
      restrict: 'E',
      templateUrl: "js/directives/widgets/profiles/profiles.html",
      replace: true,
      link: function(scope, elem, attrs) {
        scope.widgets.people = {};
        scope.widgets.people.data = [];
        scope.widgets.people.fn = {};
        scope.widgets.people.current = 0;
        scope.widgets.people.currentLearningFocus = {};
        scope.widgets.people.container = {}
        scope.widgets.people.container.classes = ['profiles','widgets'];
        if(_.has(attrs,'noBottom')) {
          scope.widgets.people.container.classes.push('no-bottom');
        }

        appDataFactory.loadData().then(function(page_data) {
          /*if(typeof page_data.sidebar.people != 'undefined') {
            scope.people = page_data.sidebar.people;
          }*/
          if(_.has(page_data.sidebar,'people') && page_data.sidebar.people.length > 0) {
            scope.widgets.people.data = page_data.sidebar.people;
            scope.widgets.people.featured = scope.widgets.people.data[scope.widgets.people.current];
          } else {
            if(_.has(page_data.sidebar,'learn') && page_data.sidebar.learn.length > 0) {
              scope.widgets.people.currentLearningFocus = page_data.sidebar.learn[scope.widgets.learningFocusIndex.value];
              if(_.has(scope.widgets.people.currentLearningFocus,'related_people')
                && scope.widgets.people.currentLearningFocus.related_people.length > 0) {
                scope.widgets.people.data = scope.widgets.people.currentLearningFocus.related_people;
                scope.widgets.people.featured = scope.widgets.people.data[scope.widgets.people.current];
              }
            }
          }

          _.forEach(scope.widgets.people.data, function(person) {
            person.classes = ['item'];
          });
          scope.widgets.people.data[0].classes.push('featured');
        });

        scope.widgets.people.fn.onAfterChange = function() {
          scope.widgets.people.current = $('#slick-people').slickCurrentSlide();
          scope.widgets.people.featured = scope.widgets.people.data[scope.widgets.people.current];
          _.forEach(scope.widgets.people.data, function(person) {
            _.remove(person.classes,function(css) { return css == 'featured'; });
          });
          scope.widgets.people.data[scope.widgets.people.current].classes.push('featured');
          scope.$apply();
        }

        scope.widgets.people.fn.get_classes = function(index) {
          return scope.widgets.people.data[index].classes;
        }

        scope.$watch('widgets.learningFocusIndex.value', function(newVal, oldVal) {
          appDataFactory.loadData().then(function(page_data) {
            scope.widgets.people.currentLearningFocus = page_data.sidebar.learn[scope.widgets.learningFocusIndex.value];
            if(_.has(scope.widgets.people.currentLearningFocus,'related_people')
              && scope.widgets.people.currentLearningFocus.related_people.length > 0) {
              scope.widgets.people.data = scope.widgets.people.currentLearningFocus.related_people;
            }
          });
        });

      }
    }
  }]);
