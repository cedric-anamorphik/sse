'use strict';

app.controller('PlanetInteractiveController', [
    '$scope',
    function($scope) {
        var onActivate = function(control) {
            var object, overlay;
            object = control.getNearestObject();
            overlay = object.element.find('.overlay').fadeOut();
            control.element.find('.overlay').not(overlay).fadeIn();
        };

        $scope.$on('planetInteractive.init', function($event, control) {
            $scope.objects = control.objects;

            $scope.moveToIndex = function(index) {
                control.moveToIndex(index, 1).then(function(position) {
                    onActivate(control);
                });
            };

            $scope.jumpToIndex = function(index) {
                var position;
                position = control.getIndexPosition(index);
                control.setPosition(position);
                onActivate(control);
            };
        });

        $scope.$on('sseInteractive.move', function($event, control) {
            onActivate(control);
        });
    }
]);