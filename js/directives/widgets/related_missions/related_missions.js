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

        if(_.has(scope.page.data.sidebar,'learn') && scope.page.data.sidebar.learn.length > 0) {
          scope.widgets.related_missions.currentLearningFocus = scope.page.data.sidebar.learn[scope.widgets.learningFocusIndex.value];
          if(_.has(scope.widgets.related_missions.currentLearningFocus,'related_missions')
            && scope.widgets.related_missions.currentLearningFocus.related_missions[0].missions.length > 0) {
            scope.widgets.related_missions.data = scope.widgets.related_missions.currentLearningFocus.related_missions[0];
            var median = Math.round(scope.widgets.related_missions.data.missions.length / 2);
            var sci = scope.widgets.related_missions.data.missions.length-median; //second column index
            console.log(median);
            console.log(sci);
            _.forEach(_.range(median), function(index) {
              scope.widgets.related_missions.columns.right.push(scope.widgets.related_missions.data.missions[index]);
            });
            console.log(scope.widgets.related_missions.columns.right);
            if(sci > 0) {
              _.forEach(_.range(sci), function(index) {
                scope.widgets.related_missions.columns.left.push(scope.widgets.related_missions.data.missions[index+median]);
              });
            }

            // _.forEach(scope.widgets.related_missions.data.missions, function(mission,index) {
            //   if(index % 2 == 0) {
            //     scope.widgets.related_missions.columns.right.push(mission);
            //   } else {
            //     scope.widgets.related_missions.columns.left.push(mission);
            //   }
            // });
            if(scope.widgets.related_missions.data.title == '') scope.widgets.related_missions.data.title = scope.widgets.related_missions.currentLearningFocus.title;
          }
        }

        scope.$watch('widgets.learningFocusIndex.value', function(newVal, oldVal) {
          if(_.has(scope.page.data.sidebar,'learn')) {
            scope.widgets.related_missions.currentLearningFocus = scope.page.data.sidebar.learn[scope.widgets.learningFocusIndex.value];
            if(_.has(scope.widgets.related_missions.currentLearningFocus,'related_missions')) {
              scope.widgets.related_missions.data = scope.widgets.related_missions.currentLearningFocus.related_missions[0];
              scope.widgets.related_missions.columns.right = [];
              scope.widgets.related_missions.columns.left = [];
              if(scope.widgets.related_missions.data.missions.length > 0) {
              var median = Math.round(scope.widgets.related_missions.data.missions.length / 2);
              var sci = scope.widgets.related_missions.data.missions.length-median; //second column index
              console.log(median);
              console.log(sci);

              _.forEach(_.range(median), function(index) {
                scope.widgets.related_missions.columns.right.push(scope.widgets.related_missions.data.missions[index]);
              });
              if(sci > 0) {
                _.forEach(_.range(sci), function(index) {
                  scope.widgets.related_missions.columns.left.push(scope.widgets.related_missions.data.missions[index+median]);
                });
              }
              }

              if(scope.widgets.related_missions.data.title == '') scope.widgets.related_missions.data.title = scope.widgets.related_missions.currentLearningFocus.title;
            }
          }
        });
      }
    }
  }]);
