'use strict';

app.directive('relatedEvents', ['appDataFactory',function(appDataFactory) {
    return {
      restrict: 'E',
      templateUrl: "js/directives/widgets/related_events/related_events.html",
      replace: true,
      link: function(scope, elem, attrs) {
        scope.widgets.events = {};
        scope.widgets.events.data = [];
        scope.widgets.events.header = '';
        scope.widgets.events.currentLearningFocus = {};
        scope.widgets.events.container = {}
        scope.widgets.events.container.classes = ['events','widgets'];
        if(_.has(attrs,'noBottom')) {
          scope.widgets.events.container.classes.push('no-bottom');
        }

        if(_.has(scope.page.data.sidebar,'learn') && scope.page.data.sidebar.learn.length > 0) {
          scope.widgets.events.currentLearningFocus = scope.page.data.sidebar.learn[scope.widgets.learningFocusIndex.value];
          if(_.has(scope.widgets.events.currentLearningFocus,'related_events')
            && scope.widgets.events.currentLearningFocus.related_events.length > 0) {
            scope.widgets.events.data = scope.widgets.events.currentLearningFocus.related_events;
            scope.widgets.events.header = scope.page.data.title.toUpperCase() + ' EVENTS';
          }
        }

      }
    }
  }]);
