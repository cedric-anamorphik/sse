'use strict';

app.directive('relatedStories', ['appDataFactory','_',function(appDataFactory,_) {
    return {
      restrict: 'E',
      templateUrl: "js/directives/widgets/related_stories/related_stories.html",
      replace: true,
      link: function(scope, elem, attrs) {
        scope.widgets.related_stories = {};
        appDataFactory.loadData().then(function(page_data) {
          /*if(typeof page_data.sidebar.missions != 'undefined') {
            scope.missions = page_data.sidebar.missions;
          }*/
          if(_.has(page_data, 'related_stories')) {
            scope.widgets.related_stories = page_data.related_stories;
          }
        });
      }
    }
  }]);
