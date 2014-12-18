'use strict';

app.directive('relatedFacts',['appDataFactory', function(appDataFactory) {
  return {
    restrict: "E",
    templateUrl: "js/directives/widgets/related_facts/related_facts.html",
    replace: true,
    link: function(scope, elem, attrs) {
      scope.widgets.related_facts = [];

      if(_.has(scope.page.data.sidebar,'facts') && scope.page.data.sidebar.facts.length > 0) {
        scope.widgets.related_facts.push(scope.page.data.sidebar.facts[0]);
      }

    }
  };
}]);
