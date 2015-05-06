'use strict';

app.directive('relatedMoons', [function() {
    return {
      restrict: 'E',
      templateUrl: "js/directives/widgets/related_moons/related_moons.html",
      replace: true,
      link: function(scope, elem, attrs) {
        scope.widgets.related_moons = {};
        scope.widgets.related_moons.fn = {};
        scope.widgets.related_moons.data = {};
        scope.widgets.related_moons.show_widget = false;
        scope.widgets.related_moons.lists = [];
/*        scope.widgets.related_moons.main = {}
        scope.widgets.related_moons.main.data = [];
        scope.widgets.related_moons.main.columns = {};
        scope.widgets.related_moons.main.columns.left = [];
        scope.widgets.related_moons.main.columns.right = [];
        scope.widgets.related_moons.provisional = {};
        scope.widgets.related_moons.provisional.data = [];
        scope.widgets.related_moons.provisional.columns = {};
        scope.widgets.related_moons.provisional.columns.left = [];
        scope.widgets.related_moons.provisional.columns.right = [];*/
        scope.widgets.related_moons.container = {}
        scope.widgets.related_moons.container.classes = ['moons','widgets'];
        if(_.has(attrs,'noBottom')) {
          scope.widgets.related_moons.container.classes.push('no-bottom');
        }

        var _processDataArray = function(cLeft, cRight, data) {
          var min_item_per_col = Math.floor(data.length / 2);
          var diff = data.length - (min_item_per_col * 2)
          angular.forEach(data,function(val,index) {
            val.index = index + 1;
            if(index < min_item_per_col + diff) {
              cLeft.push(val);
            } else {
              cRight.push(val);
            }
          });
        }

        if(_.has(scope.page.data.sidebar, 'moons')) {
          scope.widgets.related_moons.data = scope.page.data.sidebar.moons;
          _(scope.widgets.related_moons.data).each(function(list) {
            if(_.has(list,'listitems') && list.listitems.length > 0) {
              list.column_left = [];
              list.column_right = [];
              _processDataArray(list.column_left, list.column_right, list.listitems);
              scope.widgets.related_moons.show_widget = true;
            }
          });
        }
      }
    }
  }]);
