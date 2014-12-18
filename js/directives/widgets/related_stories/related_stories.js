'use strict';

app.directive('relatedStories', ['appDataFactory','_',function(appDataFactory,_) {
    return {
      restrict: 'E',
      templateUrl: "js/directives/widgets/related_stories/related_stories.html",
      replace: true,
      link: function(scope, elem, attrs) {
        scope.widgets.related_stories = {};

        if(_.has(scope.page.data, 'related_stories')) {
          scope.widgets.related_stories = scope.page.data.related_stories;
        }
      }
    }
  }]);
