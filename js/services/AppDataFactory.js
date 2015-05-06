'use strict';

angular.module('appDataFactory',['ngResource'])
.factory('appDataFactory', ['$q','$http','_',function($q, $http, _) {
  var data_local = null;
  var itemDefer = $q.defer();
  var navDefer = $q.defer();
  var api_url = {};
  var request_prefix = '';

  var factory = {
    queryData: function(prefix,stateparams) {
      api_url.page = 'json/page-json.cfm?URLPath=';
      switch(prefix) {
        case 'educ':
          api_url.page = api_url.page + 'educ/' + stateparams.page_id;
        break;

        case 'people':
          api_url.page = api_url.page + 'people/' + stateparams.person_name;
        break;

        case 'news':
          api_url.page = api_url.page + 'news/' + stateparams.news_year + '/' + stateparams.news_month + '/' + stateparams.news_day + '/' + stateparams.news_title;
        break;

    case 'galleries':
          api_url.page = api_url.page + 'galleries/';
      if(_.has(stateparams, 'galleries_sub')){
      api_url.page = api_url.page + stateparams.galleries_sub + '/' + stateparams.galleries_id;
      }
        break;

        case 'planets':
          api_url.page = api_url.page + 'planets/' + stateparams.planet_id;
          if(_.has(stateparams,'sub_id')) {
            api_url.page = api_url.page + '/' + stateparams.sub_id;
          }
        break;

        case 'missions':
          api_url.page = api_url.page + 'missions/' + stateparams.mission_id;
          if(_.has(stateparams,'sub_id')) {
            api_url.page = api_url.page + '/' + stateparams.sub_id;
          }
        break;

        case 'cmspage':
          api_url.page += stateparams.path.replace('/','');
        break;
      }
console.log(api_url.page);
      request_prefix = prefix;

      var promise = $http({method:'GET',url: api_url.page})
        .success(function (data, status, headers, config) {
          return data;
        })
        .error(function (data, status, headers, config) {
            console.error('Error fetching page feed:', data);
        });

      return promise;
    },
    queryTemplate: function(type, data) {
      var templateUrl = 'includes';
      console.log(data);
      if(type == 'sidebar') {
        var tplfolder = data.contenttype;
        if(data.contenttype == 'news') {
          tplfolder = 'page';
        }
        return 'includes/' + tplfolder + '/partial-sidebar.html';
      } else if(data.view == 'list') {
        return 'includes/list/partial-' + data.contenttype + '-list.html';
      }
      else {
        switch(data.contenttype) {
          case 'page':
          case 'news':
            templateUrl += '/page/partial-content.html';
          break;

          default:
            templateUrl += '/' + data.contenttype + '/partial-content';
            if(_.indexOf(['missions','planets'],data.contenttype,true) >= 0 && data.path.length >= 3) {
              templateUrl += '-detail';
            }
            templateUrl += '.html';
            console.log(templateUrl);
          break;
        }
        console.log(templateUrl);
        return templateUrl;
      }
    },
    getPathPrefix: function() { return request_prefix; },
    queryNav: function(path) {
      api_url.nav = 'json/nav-json.cfm?URLPath=';
      api_url.nav = api_url.nav + path;
      var promise = $http({method:'GET',url: api_url.nav})
        .success(function (data, status, headers, config) {
          return data;
        })
        .error(function (data, status, headers, config) {
          console.error('Error fetching nav feed:', data);
        });

      return promise;
    },
    processData: function(data) {
      var prefix = this.getPathPrefix();
      if(prefix == 'educ') {
        data.section = 'education';
        data.sidebar = {};
      }

      if(_.has(data,'missions')) {
        var missions_local = [];
        _.forEach(data.missions, function(mission) {
          var mission_types = mission.type.split(',');
          if(mission_types.length > 1) {
            _.forEach(mission_types, function(mtype) {
              mission.type = mtype;
              missions_local.push({
                content: mission.content,
                title: mission.title,
                type: mtype.replace(/\s+/g, '-').toLowerCase(),
                url: mission.url
              });
            });
          } else {
            missions_local.push(mission);
          }
        });
        data.missions = missions_local;
      }

      return data;
    }
  }

  return factory;
}])
.factory('sidePopFactory', function($resource){
  return  $resource('data/sidebarPop.json');
})
.factory('planetsGalFactory', function($resource){
	return  $resource('data/planetsGal.json');
})
.factory('missionsGalFactory', function($resource){
	return $resource('json/page-json.cfm?URLPath=missions');
})
.factory('missionsTypeFactory', function($resource){
	return $resource('json/page-json.cfm?URLPath=missions/type');
})
.factory('missionsTargetFactory', function($resource){
	return $resource('json/page-json.cfm?URLPath=missions/target');
})
.factory('navFactory', function($resource){
	return $resource('json/nav-json.cfm?urlpath=all');
})
.factory('peopleGalFactory', function($q, $http) {
	return {
		getPeople: function() {
			var deferred = $q.defer();
			$http.get("json/page-json.cfm?URLPath=people")
			.success(function (data) {
				deferred.resolve(data);
			})
			.error(function() {
				deferred.reject();
			});
			return deferred.promise;
		}
	};
})
.factory('newsGalFactory', function($q, $http) {
	return {
		getNews: function() {
			var deferred = $q.defer();
			$http.get("json/page-json.cfm?URLPath=news")
			.success(function (data) {
				deferred.resolve(data);
			})
			.error(function() {
				deferred.reject();
			});
			return deferred.promise;
		}
	};
})
.factory('sbFactory', function($resource){
	return $resource('json/home-sidebar-json.cfm');
})
.factory('galleriesGalFactory', function($q, $http){
	return {
		getBest: function() {
			var deferred = $q.defer();
			$http.get("json/page-json.cfm?URLPath=galleries")
			.success(function (data) {
				deferred.resolve(data);
			})
			.error(function() {
				deferred.reject();
			});
			return deferred.promise;
		}
	};
});
