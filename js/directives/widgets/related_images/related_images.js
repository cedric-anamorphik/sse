'use strict';

app.directive('relatedImages',['appDataFactory','_',function(appDataFactory,_) {
    return {
      restrict: "E",
      templateUrl: "js/directives/widgets/related_images/related_images.html",
      replace: true,
      link: function(scope, elem, attrs) {
        scope.widgets.related_images = {};
        scope.widgets.related_images.data = {};
        scope.widgets.related_images.rows = {};
        scope.widgets.related_images.rows.data = [];
        scope.widgets.related_images.rows.count = 0;
        scope.widgets.related_images.rows.per_row = 4;
        scope.widgets.related_images.rows.per_row_collection = _.range(4);
        scope.widgets.related_images.currentLearningFocus = {};
        scope.widgets.related_images.featured = {};
        scope.widgets.related_images.fn = {};
        scope.widgets.related_images.header = '';
        if(_.has(attrs,'header')) { scope.widgets.related_images.header = attrs.header; }


          if(_.has(scope.page.data.sidebar,'learn') && scope.page.data.sidebar.learn.length > 0) {
            scope.widgets.related_images.currentLearningFocus = scope.page.data.sidebar.learn[scope.widgets.learningFocusIndex.value];
            if(_.has(scope.widgets.related_images.currentLearningFocus,'related_images')
              && scope.widgets.related_images.currentLearningFocus.related_images[0].images.length > 0) {
              scope.widgets.related_images.data = scope.widgets.related_images.currentLearningFocus.related_images[0];
              scope.widgets.related_images.header = scope.widgets.related_images.data.title + ' Images';
              scope.widgets.related_images.featured = {};
              scope.widgets.related_images.featured.index = 0;
              scope.widgets.related_images.featured.image_src = scope.widgets.related_images.data.images[0].browse;
              scope.widgets.related_images.featured.alttext = scope.widgets.related_images.data.images[0].alt;
              scope.widgets.related_images.featured.title = scope.widgets.related_images.data.images[0].title;

              scope.widgets.related_images.rows.count = Math.ceil(scope.widgets.related_images.data.images.length / scope.widgets.related_images.rows.per_row);
              scope.widgets.related_images.rows.counter_collection = _.range(scope.widgets.related_images.rows.count);
            }
          }


        scope.widgets.related_images.fn.set_featured = function(row,column) {
          var index = row * scope.widgets.related_images.rows.per_row + column;
          if(scope.widgets.related_images.data.images[index] != undefined) {
          scope.widgets.related_images.featured.image_src = scope.widgets.related_images.data.images[index].browse;
          scope.widgets.related_images.featured.alttext = scope.widgets.related_images.data.images[index].alt;
          scope.widgets.related_images.featured.title = scope.widgets.related_images.data.images[0].title;
          scope.widgets.related_images.featured.index = index;
          }
        }

        scope.widgets.related_images.fn.is_featured = function(index) {
          if(scope.widgets.related_images.featured.index == index) return 'featured';
        }

        scope.widgets.related_images.fn.gallery_item_classes = function(index) {
          var classes = ['thumb','col-md-3','col-sm-3','col-xs-3'];
          if(index == 0) classes.push('first');
          return classes;
        }

        scope.widgets.related_images.fn.gallery_collection_classes = function(index) {
          var classes = ['thumb-collection','clearfix'];
          if(index == 0) classes.push('first');
          return classes;
        }

        scope.widgets.related_images.fn.load_thumbnail_info = function(row, column, info) {
          if(scope.widgets.related_images.data.images[row * scope.widgets.related_images.rows.per_row + column] != undefined) {
            return scope.widgets.related_images.data.images[row * scope.widgets.related_images.rows.per_row + column][info];
          } else {
            if(info == 'thumbnail') return 'images/spacer.gif';
            if(info == 'alt') return '';
          }
        }

        scope.$watch('widgets.learningFocusIndex.value', function(newVal, oldVal) {
            if(_.has(scope.page.data.sidebar,'learn')) {
              scope.widgets.related_images.currentLearningFocus = scope.page.data.sidebar.learn[scope.widgets.learningFocusIndex.value];
              if(_.has(scope.widgets.related_images.currentLearningFocus,'related_images')
                && scope.widgets.related_images.currentLearningFocus.related_images[0].images.length > 0) {
                scope.widgets.related_images.data = scope.widgets.related_images.currentLearningFocus.related_images[0];
                scope.widgets.related_images.header = scope.widgets.related_images.data.title + ' Images';
                scope.widgets.related_images.featured.index = 0;
                scope.widgets.related_images.featured.image_src = scope.widgets.related_images.data.images[0].browse;
                scope.widgets.related_images.featured.alttext = scope.widgets.related_images.data.images[0].alt;
                scope.widgets.related_images.featured.title = scope.widgets.related_images.data.images[0].title;
              }
            }
        });

      }
    };
  }]);
