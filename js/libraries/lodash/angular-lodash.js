'use strict';

var lodash = angular.module('lodash', []);
lodash.factory('_', function() {
  return window._; // assumes underscore has already been loaded on the page
});
