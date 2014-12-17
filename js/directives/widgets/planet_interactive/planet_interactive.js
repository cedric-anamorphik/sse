'use strict';

app.directive('planetInteractive', [
    '$window', '$document', '$q', '$timeout', 
    function($window, $document, $q, $timeout) {
        var controller, link, preloadObject;

        controller = ['$scope', '$element', function($scope, $element) {
            var computeObjectPosition;

            controller = this;

            $scope.objects = [];
            $scope.position = $scope.initial || 0;

            ($scope.onResize = function() {
                var elem;
                elem = $element.children('.planet-interactive-objects');
                $scope.width = elem.width();
                return $scope.height = elem.height();
            })();

            computeObjectPosition = function(position, index) {
                var display, length;
                length = $scope.objects.length - 1;
                display = $scope.display - 1;
                return 1 + (index - position * length) / display;
            };

            this.element = $element;
            this.objects = $scope.objects;

            this.getObject = function(index) {
                return $scope.objects[index];
            };

            this.addObject = function(object) {
                var index;
                index = $scope.objects.length;
                return $scope.objects.push(object);
            };

            this.getNearestObject = function() {
                var index;
                index = this.getNearestIndex();
                return this.getObject(index);
            };

            this.getNearestIndex = function() {
                var length, position;
                position = $scope.position;
                length = $scope.objects.length - 1;
                return Math.ceil(position * length);
            };

            this.getIndexPosition = function(index) {
                return index / ($scope.objects.length - 1);
            };

            this.getPosition = function() {
                return $scope.position;
            };

            this.setPosition = function(position) {
                var i, object, pos, _i, _len, _ref;
                if (this.stopmove !== angular.noop) {
                    this.stopMove();
                }
                _ref = $scope.objects;
                for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
                    object = _ref[i];
                    pos = computeObjectPosition(position, i);
                    object.setPosition(pos);
                }
                return $scope.position = position;
            };

            this.moveToIndex = function(index, speed) {
                var position;
                if ($scope.objects[index] != null) {
                    position = this.getIndexPosition(index);
                    return this.movePosition(position, speed);
                }
            };

            this.moveToNearest = function(speed) {
                return this.moveToIndex(this.getNearestIndex(), speed);
            };

            this.stopMove = angular.noop;

            this.movePosition = function(position, speed) {
                var defer, display, duration, fromPosition, i, length, 
                    object, toPosition, tween, tweens, _i, _len, _ref;

                this.stopMove();
                defer = $q.defer();

                if (position === $scope.position) {
                    defer.resolve($scope.position);
                } 
                else {
                    length = $scope.objects.length - 1;
                    display = $scope.display - 1;
                    duration = speed * (position - $scope.position);

                    tweens = [];
                    tweens.push(TweenMax.to($scope, duration, {
                        position: position,
                        ease: Linear.easeNone,
                        onUpdate: function() {
                            return defer.notify($scope.position);
                        },
                        onComplete: function() {
                            this.stopMove = angular.noop;
                            return defer.resolve($scope.position);
                        }
                    }));
                    _ref = $scope.objects;
                    for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
                        object = _ref[i];
                        fromPosition = computeObjectPosition($scope.position, i);
                        toPosition = computeObjectPosition(position, i);
                        if (tween = object.movePosition(toPosition, fromPosition, speed)) {
                            tweens.push(tween);
                        }
                    }
                    this.stopMove = function() {
                        var _j, _len1;
                        for (_j = 0, _len1 = tweens.length; _j < _len1; _j++) {
                            tween = tweens[_j];
                            tween.kill();
                        }
                        defer.reject();
                        return this.stopMove = angular.noop;
                    };
                }
                return defer.promise;
            };

            return this;
        } ];

        preloadObject = function(object) {
            var defer, _ref;
            defer = $q.defer();
            if (!object.preloaded) {
                object.preloaded = true;
                if ((_ref = object.element) != null) {
                    _ref.find('img').each(function() {
                        return $(this).attr('src', $(this).attr('data-src')).load(function(e) {
                            return defer.resolve(e);
                        }).error(function(e) {
                            return defer.reject(e);
                        });
                    });
                }
            }
            return defer.promise;
        }; 

        link = function(scope, element, attrs, controller) {
            var i, mousewheelTimer, object, startIndex, _i, _j, _len, _ref, _ref1;
            jQuery($window).on('resize', scope.onResize);
            controller.setPosition(parseFloat(scope.initial) || 0);
            startIndex = controller.getNearestIndex();

            for (i = _i = startIndex, _ref = startIndex - scope.display; _i >= _ref; i = _i += -1) {
                if (i < 0) {
                    break;
                }
                preloadObject(scope.objects[i]);
            }

            _ref1 = scope.objects;
            for (_j = 0, _len = _ref1.length; _j < _len; _j++) {
                object = _ref1[_j];
                preloadObject(object);
            }

            element.on('mousedown', function(e) {
                var onMousemove, position, startX, startY;
                if (e.which !== 1) {
                    return;
                }
                e.preventDefault();
                controller.stopMove();
                position = scope.position;
                startX = e.pageX;
                startY = e.pageY;

                onMousemove = function(e) {
                    var delta, deltaX, deltaY;
                    e.preventDefault();
                    deltaX = (e.pageX - startX) / scope.width;
                    deltaY = (e.pageY - startY) / scope.height;
                    delta = deltaY + deltaX;
                    controller.setPosition(Math.max(Math.min(position - delta, 1), 0));
                    return scope.$emit('planetInteractive.move', controller);
                };

                scope.$emit('planetInteractive.startmove', controller);
                $document.on('mousemove', onMousemove);

                return $document.one('mouseup', function(e) {
                    $document.off('mousemove', onMousemove);
                    return controller.moveToNearest(1).then(function() {
                        scope.$emit('planetInteractive.stopmove', controller);
                        return scope.$emit('planetInteractive.snap', controller);
                    });
                });
            });
            mousewheelTimer = null;
            element.on('mousewheel', function(e) {
                var delta, deltaX, deltaY, position;
                e.preventDefault();
                controller.stopMove();
                deltaX = e.deltaFactor * e.deltaX / scope.width;
                deltaY = e.deltaFactor * e.deltaY / scope.height;
                delta = deltaY - deltaX;
                position = Math.max(Math.min(scope.position - delta, 1), 0);
                if (!mousewheelTimer) {
                    scope.$emit('planetInteractive.startmove', controller);
                }

                controller.setPosition(position);
                scope.$emit('planetInteractive.move', controller);
                if (mousewheelTimer != null) {
                    $timeout.cancel(mousewheelTimer);
                }

                return mousewheelTimer = $timeout(function() {
                    controller.moveToNearest(1);
                    scope.$emit('planetInteractive.stopmove', controller);
                    return scope.$emit('planetInteractive.snap', controller);
                }, 1000, false);
            });
            return scope.$emit('planetInteractive.init', controller);
        };
        return {
            restrict: 'C',
            transclude: true,
            scope: {
                initial: '@',
                display: '=',
                control: '=',
                onSnap: '&'
            },
            template: '<div class="planet-interactive-objects" ng-transclude></div>',
            controller: controller,
            link: link
        };
    }
]);

app.directive('planetInteractiveObject', [
    '$animate', '$q', 
    function($animate, $q) {
        var link;
        link = function(scope, element, attrs, controller) {
            var boundPosition, getPositionOpacity, getPositionStyles, 
                hideElement, isPositionVisible, maxBound, minBound, 
                setVisibility, showElement;

            scope.index = controller.addObject(scope);
            scope.visible = false;
            scope.element = element;
            minBound = 0;
            maxBound = 1.25;

            showElement = function(position, duration) {
                var opacity;
                element.addClass('planet-interactive-visible');
                if (!scope.visible) {
                    opacity = getPositionOpacity(position);
                    if (duration != null) {
                        TweenMax.to(element, duration, {
                            opacity: opacity
                        });
                    } else {
                        element.css({
                            opacity: opacity
                        });
                    }
                }
                scope.visible = true;
            };

            hideElement = function(duration) {
                if (scope.visible) {
                    if (duration != null) {
                        TweenMax.to(element, duration, {
                            opacity: 0,
                            onComplete: function() {
                                element.removeClass('planet-interactive-visible');
                            }
                        });
                    } else {
                        element.css({
                            opacity: 0
                        });
                        element.removeClass('planet-interactive-visible');
                    }
                }
                scope.visible = false;
            };

            setVisibility = function(position, duration) {
                if (isPositionVisible(position)) {
                    showElement(position, duration);
                } else {
                    hideElement(duration);
                }
            };

            getPositionOpacity = function(position) {
                return Math.max(Math.min(.8 * position + .2, 1), 0);
            };

            getPositionStyles = function(position) {
                var size;
                size = 75 * position + 25;
                size = parseFloat(Math.max(size, 0));
                return {
                    top: -10 * position + 10 + '%',
                    left: -10 * position + 10 + '%',
                    width: size + '%',
                    height: size + '%'
                };
            };

            boundPosition = function(position) {
                var bound;
                bound = Math.min(position, maxBound);
                if (bound === maxBound) {
                    return bound;
                }
                return Math.max(bound, minBound);
            };

            isPositionVisible = function(toPosition, fromPosition) {
                var maxPosition, minPosition;
                if (fromPosition != null) {
                    minPosition = Math.min(toPosition, fromPosition);
                    maxPosition = Math.max(toPosition, fromPosition);
                    return maxPosition >= minBound && minPosition <= maxBound;
                } else {
                    return boundPosition(toPosition) === toPosition;
                }
            };

            scope.setPosition = function(position) {
                var styles;
                styles = getPositionStyles(position);
                styles.opacity = getPositionOpacity(position);
                element.css(styles);
                setVisibility(position, .3);
            };

            scope.movePosition = function(toPosition, fromPosition, speed) {
                var boundFrom, boundTo, delay, fromStyles, time, toStyles;
                if (isPositionVisible(toPosition, fromPosition)) {
                    boundFrom = boundPosition(fromPosition);
                    boundTo = boundPosition(toPosition);
                    time = Math.abs(boundTo - boundFrom) * speed;
                    delay = Math.abs(fromPosition - boundFrom) * speed;
                    fromStyles = getPositionStyles(boundFrom);
                    fromStyles.opacity = getPositionOpacity(boundFrom);
                    toStyles = getPositionStyles(boundTo);
                    toStyles.opacity = getPositionOpacity(boundTo);

                    return TweenMax.fromTo(element, time, fromStyles, {
                        css: toStyles,
                        delay: delay,
                        ease: fromPosition < toPosition && Quad.easeIn || Quad.easeOut,
                        onStart: function() {
                            showElement(boundFrom);
                        },
                        onComplete: function() {
                            setVisibility(toPosition);
                        }
                    });
                } else {
                    hideElement();
                }
            };
        };

        return {
            require: '^planetInteractive',
            restrict: 'C',
            transclude: true,
            template: '<div class="planet-interactive-object-scale" id="{{name}}" ng-transclude></div>',
            scope: {
                name: '@'
            },
            link: link
        };
    } 
]);