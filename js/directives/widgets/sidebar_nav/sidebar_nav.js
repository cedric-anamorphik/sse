'use strict';

app.directive('sidebarNav',['appDataFactory', function(appDataFactory) {
  return {
    restrict: "E",
    templateUrl: "js/directives/widgets/sidebar_nav/sidebar_nav.html",
    replace: true,
    scope: {
      navPath: '=',
      mainData: '='
    },
    link: function(scope, elem, attrs) {
      scope.widgets = {};
      scope.widgets.sidebar_nav = {};
      scope.widgets.sidebar_nav.tabs = {};
      scope.widgets.sidebar_nav.tabs.primary = {};
      scope.widgets.sidebar_nav.tabs.primary.header = '';
      scope.widgets.sidebar_nav.tabs.primary.data = [];
      scope.widgets.sidebar_nav.tabs.secondary = {};
      scope.widgets.sidebar_nav.tabs.secondary.header = '';
      scope.widgets.sidebar_nav.tabs.secondary.data = [];
      scope.widgets.sidebar_nav.fn = {};
      scope.widgets.sidebar_nav.container = {}
      scope.widgets.sidebar_nav.container.classes = ['sidebar-nav','nav-panel','widgets'];
      if(_.has(attrs,'noBottom')) {
        scope.widgets.sidebar_nav.container.classes.push('no-bottom');
      }
      /*console.log(scope.navPath);
      console.log('scope.mainData');
console.log(scope.mainData);*/
      if(_.has(scope.mainData.sidebar,'subnav') && scope.mainData.sidebar.subnav.length > 0) {
        scope.widgets.sidebar_nav.tabs.primary.data = scope.mainData.sidebar.subnav;
        scope.widgets.sidebar_nav.tabs.primary.header = scope.mainData.title.toUpperCase();
        //console.log('appDataFactory.getPathPrefix(): ' + appDataFactory.getPathPrefix());
        appDataFactory.queryNav(scope.navPath).then(function(response) {
          /*console.log(response.data.section);
          console.log(attrs);*/
          var nav = _.find(response.data.section, function(nav_data) {
            //console.log(nav_data.sectionName);
            //console.log(scope.navPath);
            return nav_data.sectionName.toLowerCase() == scope.navPath.toLowerCase()
          });
          //console.log(nav);
          if(_.has(nav,'sub') && nav.sub.length > 0) {
            scope.widgets.sidebar_nav.tabs.secondary.data = nav.sub;
          }
          /*console.log(nav);*/
          scope.widgets.sidebar_nav.tabs.secondary.header = nav.sectionName.toUpperCase();
        });
      }
    }
  };
}]);
