'use strict';

app.directive('featuredCarousel',['appDataFactory', function(appDataFactory) {
  return {
    restrict: "E",
    templateUrl: "js/directives/widgets/featured_carousel/featured_carousel.html",
    replace: true,
    link: function(scope, elem, attrs) {
      scope.widgets.featured_carousel = {};
      scope.widgets.featured_carousel.data = [];
      scope.widgets.featured_carousel.fn = {};
      scope.widgets.featured_carousel.interval = 10000;

      if(_.has(scope.page.data.main,'slideshow') && scope.page.data.main.slideshow.length > 0) {
        scope.widgets.featured_carousel.data = scope.page.data.main.slideshow;
        _.forEach(scope.widgets.featured_carousel.data, function(val, index) {
          if(index == 0) { val.active = true; } else { val.active = false; }
          var slide_content = '';
          if(val.title != '') slide_content += val.title + '<br>';
          if(val.subtitle != '') slide_content += val.subtitle + '<br>';
          if(val.content != '') slide_content += val.content;
          val.content = slide_content;
        });
        //console.log('carousel data');
        //console.log(scope.widgets.featured_carousel.data);
      }

      scope.widgets.featured_carousel.fn.initialSlide = function(index) {
        var classes = ['item'];
        if(index == 0) { classes.push('active'); }
        return classes;
      }

    }
  };
}]);
