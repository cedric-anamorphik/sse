'use strict';

app.directive('relatedMissions', ['appDataFactory',function(appDataFactory) {
    return {
      restrict: 'E',
      templateUrl: "js/directives/widgets/related_missions/related_missions.html",
      replace: true,
      link: function(scope, elem, attrs) {
        scope.widgets.related_missions = {};
        scope.widgets.related_missions.data = {};
        scope.widgets.related_missions.currentLearningFocus = {};
        scope.widgets.related_missions.columns = {};
        scope.widgets.related_missions.columns.right = [];
        scope.widgets.related_missions.columns.left = [];
        scope.widgets.related_missions.container = {}
        scope.widgets.related_missions.container.classes = ['missions','widgets'];
        if(_.has(attrs,'noBottom')) {
          scope.widgets.related_missions.container.classes.push('no-bottom');
        }

        appDataFactory.loadData().then(function(page_data) {
          if(_.has(page_data.sidebar,'learn') && page_data.sidebar.learn.length > 0) {
            scope.widgets.related_missions.currentLearningFocus = page_data.sidebar.learn[scope.widgets.learningFocusIndex.value];
            if(_.has(scope.widgets.related_missions.currentLearningFocus,'related_missions')
              && scope.widgets.related_missions.currentLearningFocus.related_missions[0].missions.length > 0) {
              scope.widgets.related_missions.data = scope.widgets.related_missions.currentLearningFocus.related_missions[0];
              if(scope.widgets.related_missions.data.title == '') scope.widgets.related_missions.data.title = scope.widgets.related_missions.currentLearningFocus.title;
            }
          }
        });

        scope.$watch('widgets.learningFocusIndex.value', function(newVal, oldVal) {
          appDataFactory.loadData().then(function(page_data) {
            if(_.has(page_data.sidebar,'learn')) {
              scope.widgets.related_missions.currentLearningFocus = page_data.sidebar.learn[scope.widgets.learningFocusIndex.value];
              if(_.has(scope.widgets.related_missions.currentLearningFocus,'related_missions')
                && scope.widgets.related_missions.currentLearningFocus.related_missions[0].missions.length > 0) {
                scope.widgets.related_missions.data = scope.widgets.related_missions.currentLearningFocus.related_missions[0];
              }
            }
          });
        });
      }
    }
  }]);
