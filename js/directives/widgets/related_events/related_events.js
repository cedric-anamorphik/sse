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
        scope.widgets.events.container = {}
        scope.widgets.events.container.classes = ['events','widgets'];
        if(_.has(attrs,'noBottom')) {
          scope.widgets.events.container.classes.push('no-bottom');
        }

        if(_.has(scope.page.data.sidebar,'related_events') && scope.page.data.sidebar.related_events.length > 0) {
          scope.widgets.events.data = scope.page.data.sidebar.related_events;
          scope.widgets.events.header = scope.page.data.title.toUpperCase() + ' EVENTS';
        }
      }
    }
  }]);
