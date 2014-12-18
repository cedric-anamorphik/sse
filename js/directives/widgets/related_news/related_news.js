'use strict';

app.directive('relatedNews', ['appDataFactory',function(appDataFactory) {
    return {
      restrict: 'E',
      templateUrl: "js/directives/widgets/related_news/related_news.html",
      replace: true,
      link: function(scope, elem, attrs) {
        scope.widgets.news = {};
        scope.widgets.news.data = [];
        scope.widgets.news.more_url = {};
        scope.widgets.news.limitTo = 3;
        scope.widgets.news.fn = {};
        scope.widgets.news.container = {}
        scope.widgets.news.container.classes = ['related-news','content-widget','clearfix'];
        console.log(_.has(attrs,'lastElement'));
        if(_.has(attrs,'lastElement')) {
          scope.widgets.news.container.classes.push('last');
        }

        if(_.has(scope.page.data, 'related_stories') && scope.page.data.related_stories.length > 0) {
          scope.widgets.news.data = scope.page.data.related_stories;

        }

        if(_.has(scope.page.data, 'related_url') && scope.page.data.related_url != '') {
          scope.widgets.news.more_url = scope.page.data.related_url;
        }

        scope.widgets.news.fn.showThumbnail = function(item) {
          return _.has(item,'image');
        }
      }
    }
  }]);
