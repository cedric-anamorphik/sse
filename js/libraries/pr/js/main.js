'use strict';

/**
 * RequestAnimationFrame Polyfill
 */
var lastTime = 0;
var vendors = ['ms', 'moz', 'webkit', 'o'];
for(var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
  window.requestAnimationFrame = window[vendors[x]+'RequestAnimationFrame'];
  window.cancelAnimationFrame = window[vendors[x]+'CancelAnimationFrame'] || window[vendors[x]+'CancelRequestAnimationFrame'];
}

if (!window.requestAnimationFrame) {
  window.requestAnimationFrame = function(callback, element) {
    var currTime = new Date().getTime();
    var timeToCall = Math.max(0, 16 - (currTime - lastTime));
    var id = window.setTimeout(function() { callback(currTime + timeToCall); }, 
      timeToCall);
    lastTime = currTime + timeToCall;
    return id;
  };
}

if (!window.cancelAnimationFrame) {
  window.cancelAnimationFrame = function(id) {
    clearTimeout(id);
  };
}

/**
 * Linear transform generator of the form
 *   y = ((x - x1) * (y2 - y1) / (x2 - x1)) + y1
 * where x1 = -visible and x2 = visible
 * with y1 = min and y2 = max
 */
var linear = function(min, max, visible) {
  var a = visible,
      m = (max - min) / (2 * a);

  return function(pos) {
    return m * (pos + a) + min;
  };
};

/**
 * Quadractive transform generator of the form
 *   y = (min - max) * x^2 / visible^2 + max
 * where max is the value at x = 0
 * where min is the value at x = visible and -visible 
 */
var quadratic = function(min, max, visible) {
  var a = (min - max) / Math.pow(visible, 2),
      b = max;

  return function(pos) {
    return a * pos * pos + b;
  };
};

/**
 * Arg Segment transform generator of the form
 *   r = (h / 2) + (w^2 / (8 * h))
 */
var arcseg = function(w, h, visible) {
  var d = Math.pow(w, 2) / (8 * h)  - (h / 2),
      r = h + d,
      z = Math.acos(d / r),
      a = z / visible;

  return function(pos) {
    var rad = (Math.PI / 2) - (a * pos);

    return {
      x: Math.cos(rad) * r,
      y: Math.sin(rad) * r - d,
    };
  };
};

/**
 * Cubic Bezier In and Out
 */
var easingCubicBezierInOut = function (t, b, c, d) {
  t /= d / 2;

  if (t < 1) {
    return c / 2 * t * t * t + b;
  }
  else {
    t -= 2;
    return c / 2 * (t * t * t + 2) + b;
  }
};

/**
 * @ngdoc function
 * @name angularJsApp.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the angularJsApp
 */
angular.module('sse.pr',[])
  .controller('MainCtrl', function($scope) {
    $scope.onRender = function(position) {
      console.log(position);
    };
  })

  // .controller('webGLInteractiveController', function($scope) {
  //   $scope.scene = new THREE.Scene();
  
  //   $scope.camera = new THREE.PerspectiveCamera(45, 1, 0.01, 5000);
  //   $scope.camera.position.z = 1.5;
    
  //   $scope.renderer = new THREE.WebGLRenderer({
  //     antialias: true,
  //     alpha: true
  //   });
    
  //   $scope.mars = function() {
  //     var geometry  = new THREE.SphereGeometry(0.5, 32, 32);
  //     var material  = new THREE.MeshPhongMaterial({
  //       map: THREE.ImageUtils.loadTexture('images/mars-map@1x.jpg'),
  //       bumpMap: THREE.ImageUtils.loadTexture('images/mars-bump@1x.jpg'),
  //       bumpScale: 0.05
  //     });

  //     var mesh  = new THREE.Mesh(geometry, material);
  //     return mesh;
  //   };
  // })

  .controller('interactiveController', function($scope) {
    var self = this,
        slides = $scope.slides = [],
        visible = $scope.visible,
        animation;

  	this.addSlide = function(slide, element) {
  		slide.$element = element;
      return slides.push(slide) - 1;
  	};

  	this.removeSlide = function(slide) {
  		var index = slides.indexOf(slide);
    	slides.splice(index, 1);
  	};

    this.select = function(slide, callback) {
      var index = slides.indexOf(slide);

      if (index !== -1) {
        this.stop();
        this.unselect();

        slide.active = true;
        $scope.selected = index;

        this.animate(index, callback);
      }
    };

    this.animate = function(position, callback) {
      var time = new Date().getTime(),
          start = $scope.position,
          delta = position - start,
          duration = Math.abs(delta) * 400;

      var animator = function() {
        var now = new Date().getTime(),
            current = now - time,
            pos = easingCubicBezierInOut(current, start, delta, duration);

        if (current < duration) {
          $scope.$evalAsync(function() {
            $scope.position = pos;
          });
          window.requestAnimationFrame(animator);
        }
        else {
          $scope.$evalAsync(function() {
            $scope.position = $scope.selected;

            if (angular.isFunction(callback)) {
              callback($scope);
            }
          });
        }
      };

      animation = window.requestAnimationFrame(animator);
    };

    this.stop = function(jumpToEnd) {
      if (animation) {
        window.cancelAnimationFrame(animation);

        if ($scope.selected && jumpToEnd) {
          $scope.$evalAsync(function() {
            $scope.position = $scope.selected;
          });
        }
      }
    };

    this.unselect = function(slide) {
      if (!angular.isDefined(slide)) {
        slide = slides[$scope.selected];
      }
      
      if (slide) {
        slide.active = false;
      }
    };

    var minSize = 10,
        maxSize = 18,
        arcHeight = 40,
        arcWidth = 100;

    var getSize = quadratic(minSize, maxSize, $scope.visible),
        getCoord = arcseg(arcWidth, arcHeight, $scope.visible);

    var transformStyles = function(position, styles) {
      var size = getSize(position),
          coord = getCoord(position);

      styles.width = size + '%';
      styles.marginLeft = (-size / 2) + '%';
      styles.top = coord.y * 100 / arcHeight + 'px';
      styles.left = (coord.x + 50) + '%';
    };

    this.render = function(position) {
      if ($scope.onRender) {
        $scope.onRender({position: position});
      }

      angular.forEach(slides, function(slide, i) {
        var styles = slide.styles;
        var pos = slide.position = i - position;

        if (-visible <= pos && pos <= visible) {
          if (!slide.visible) {
            slide.visible = true;
          }

          transformStyles(pos, styles);
        }
        else {
          slide.visible = false;
        }
      });
    };
  })

  .directive('interactive', function($document) {
  	return {
	    restrict: 'E',
	    transclude: true,
      replace: true,
	    controller: 'interactiveController',
	    require: 'interactive',
      template: '<div class="interactive">' + 
                  '<div class="glyphicon glyphicon-chevron-left control left" ng-click="prev()"></div>' +
                  '<div class="glyphicon glyphicon-chevron-right control right" ng-click="next()"></div>' +
                  '<div class="interactive-inner" ng-transclude></div>' +
                '</div>',
	    scope: {
        visible: '=',
        onRender: '&'
      },
      link: function(scope, element, attrs, interactiveCtrl) {
        attrs.$observe('position', function(pos) {
          var position = parseInt(pos);

          if (!isNaN(position)) {
            scope.position = position;
          }
        });

        scope.prev = function() {
          var prev = Math.round(scope.position - 1);
          if (scope.slides[prev]) {
            interactiveCtrl.select(scope.slides[prev]);
          }
        };

        scope.next = function() {
          var next = Math.round(scope.position + 1);
          if (scope.slides[next]) {
            interactiveCtrl.select(scope.slides[next]);
          }
        };
        
        scope.$watch('position', function(position) {
          interactiveCtrl.render(position);
        });
        
        scope.$watchCollection('slides', function(slides) {
          if (slides.length && !isNaN(scope.position)) {
            interactiveCtrl.render(scope.position);
          }
        });

        element.find('.interactive-inner').on({
          mousedown: function(e) {
            if (e.which === 1) {
              e.preventDefault();

              var position = scope.position,
                  start = e.pageX,
                  range = element.width();

              interactiveCtrl.unselect();

              var deactivate = function(e) {
                $document.off('.interactive');
                var nearest = scope.slides[Math.round(scope.position)];

                if (nearest) {
                  interactiveCtrl.select(nearest);
                }
              };

              $document.on({
                'mouseup.interactive': deactivate,
                'mouseleave.interactive': deactivate,
                'mousemove.interactive': function(e) {
                  var delta = e.pageX - start,
                      step = 2 * scope.visible / range;

                  scope.$apply(function() {
                    scope.position = position - delta * step;
                  });
                }
              });
            }
          }
        });
      }
	  };
  })

  .directive('interactiveObject', function() {
  	return {
	    require: '^interactive',
	    restrict: 'E',
	    transclude: true,
      replace: true,
      scope: {},
      template: '<div ng-style="styles" class="interactive-object" ng-class="{active: active}" ng-transclude></div>',
	    link: function(scope, element, attrs, interactiveCtrl) {
        var styles = scope.styles = {};
        
        scope.$watch('visible', function(isVisible) {
          if (isVisible) {
            styles.display = 'block';
          }
          else {
            styles.display = 'none';
          }
        });

	    	interactiveCtrl.addSlide(scope, element);

	    	scope.$on('$destroy', function() {
	        interactiveCtrl.removeSlide(scope);
	      });
	    }
	  };
  });
