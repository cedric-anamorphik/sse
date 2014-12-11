angular.module("sse.services", [])
        .factory("sidebarService", function($http) {
			var sidebar = {};

			// Get sidebar data
			sidebar.getData = function(){
				$http.get("json/home-sidebar-json.")
					.success(function(data, status, headers, config) {
						console.log($scope.test);
					})
					.error(function(data, status, headers, config){
						alert("We're sorry, but the planetary data you requested is experiencing problems loading at this time.");
					});
				}

			return sidebar;
        });


angular.module("sse.controllers", [])
.controller("SidebarCtrl", function ($http) {
  var vm = this;
  $http.get("data/sidebar.json").success(function (data) {
    vm.data = data;
  });
});

attempt 1

angular.module("sse.directives", [])
.controller("SidebarCtrl", function ($http) {
  var vm = this;
  $http.get("data/sidebar.json").success(function (data) {
    vm.planetName = data.planetName;
  });
})
.directive("Sidebar", function () {
  return {
    restrict: 'E', // <sidebar></sidebar>
    template: '<div>{{vm.planetName}}</div>'
  };
});


attempt 2

angular.module("sse.directives", [])
.controller("SidebarCtrl", function ($http) {
  var vm = this;
  $http.get("data/sidebar.json").success(function (data) {
    vm.data = data;
  });
})
.directive("Sidebar", function () {
  return {
    restrict: 'E', // <sidebar></sidebar>
    template: '<div>{{vm.data.planetName}}</div>'
  };
});



then on a page

<sidebar></sidebar>


<><><><><><>

angular.module("sse.controllers", [])
.controller("SidebarCtrl", function ($http) {
  var vm = this;
  $http.get("data/sidebar.json").success(function (data) {
    vm.data = data;
  });
});



angular.module("sse.directives", [])

.directive("Sidebar", function () {
  return {
    restrict: 'E',
    template: '<div>{{vm.data.planetName}}</div>',
    controller: function ($http) {
      var vm = this;
      $http.get("data/sidebar.json").success(function (data) {
        vm.data = data;
      });
    }
  };
});

<><><><><>


angular.module("sse.controllers", [])
.controller("SidebarCtrl", function ($http) {
  var vm = this;
  $http.get("data/sidebar.json").success(function (data) {
    vm.data = data;
  });
});



angular.module("sse.directives", [])

.directive("Sidebar", function () {
  return {
    restrict: 'E',
    template: '<div>{{vm.data.planetName}}</div>',
    controller: function ($http) {
      var vm = this;
      $http.get("data/sidebar.json").success(function (data) {
        vm.data = data;
      });
    }
  };
});

<><><><><>

angular.module("sse.services", [])
        .factory("sidebarService", function($http) {
			var sidebar = {};

			// Get sidebar data
			sidebar.getData = function(){
				$http.get("services/homeSidebar.json")
					.success(function(data, status, headers, config) {
						console.log($scope.test);
					})
					.error(function(data, status, headers, config){
						alert("We're sorry, but the planetary data you requested is experiencing problems loading at this time.");
					});
				}

			return sidebar;
        });

angular.module("sse.controllers", [])
.controller("SidebarCtrl", function ($http) {
  var vm = this;
  $http.get("data/sidebar.json").success(function (data) {
    vm.data = data;
  });
});



angular.module("sse.directives", [])

.directive("Sidebar", function () {
  return {
    restrict: 'E',
    template: '<div>{{vm.data.planetName}}</div>',
    controller: function ($http) {
      var vm = this;
      $http.get("data/sidebar.json").success(function (data) {
        vm.data = data;
      });
    }
  };
});
