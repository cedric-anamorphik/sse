'use strict';

app.directive('relatedFacts',['appDataFactory', function(appDataFactory) {
  return {
    restrict: "E",
    templateUrl: "js/directives/widgets/related_facts/related_facts.html",
    replace: true,
    link: function(scope, elem, attrs) {
      scope.widgets.related_facts = [];
      appDataFactory.loadData().then(function(page_data) {
        /*if(typeof page_data.sidebar.facts != 'undefined') {
          scope.facts = page_data.sidebar.facts;
        }*/
        if(_.has(page_data.sidebar,'facts') && page_data.sidebar.facts.length > 0) {
          scope.widgets.related_facts.push(page_data.sidebar.facts[0]);
        }
      });
    }
  };
}]);
