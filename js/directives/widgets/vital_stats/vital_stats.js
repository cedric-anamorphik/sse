'use strict';

app.directive('vitalStats', ['appDataFactory', function(appDataFactory) {
  return {
    restrict: "E",
    templateUrl: "js/directives/widgets/vital_stats/vital_stats.html",
    replace: true,
    link: function(scope, elem, attrs) {
      if(!_.has(scope.widgets,'vital_stats')) {
        scope.widgets.vital_stats = {};
      }
      scope.widgets.vital_stats.missions = {};
      scope.widgets.vital_stats.missions.data = [];
      scope.widgets.vital_stats.missions.selected = {};
      scope.widgets.vital_stats.missions.fn = {};
      scope.widgets.vital_stats.stats_include = '';

      if(_.has(scope.page.data,'missions')) {
        scope.widgets.vital_stats.missions.data = scope.page.data.missions;
        _.forEach(scope.widgets.vital_stats.missions.data,function(mission) {
          mission.classes = ['col-md-2','col-sm-3','col-xs-4','spritz','mission-' + mission.type.toLowerCase()];
        });
        scope.widgets.vital_stats.missions.data[0].classes.push('active');
        scope.widgets.vital_stats.missions.selected = scope.widgets.vital_stats.missions.data[0];
      }

      if(_.has(scope.page.data,'vitalstats')) {
        scope.widgets.vital_stats.stats_include = scope.page.data.vitalstats;
      }

      scope.widgets.vital_stats.missions.fn.select = function(index) {
        scope.widgets.vital_stats.missions.selected = scope.widgets.vital_stats.missions.data[index];
        _.forEach(scope.widgets.vital_stats.missions.data,function(mission) {
          _.remove(mission.classes,function(css) { return css == 'active'; });
        });
        scope.widgets.vital_stats.missions.data[index].classes.push('active');
      }

      scope.widgets.vital_stats.missions.fn.mission_icon_classes = function(index) {
        var icon_classes = scope.widgets.vital_stats.missions.data[index].classes;
        return icon_classes;
      }
    }
  }
}]);
