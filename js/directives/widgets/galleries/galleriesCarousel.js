'use strict';

app.directive('firstimage', function() {
  return function(scope, element, attrs) {
    if (scope.$first){
		// window.alert("im the last!");
		angular.element(element).addClass("selected");
    }
  };
})
app.directive('firstnav', function() {
  return function(scope, element, attrs) {
    if (scope.$first){
		// window.alert("im the last!");
		angular.element(element).addClass("active");
    }
  };
});

$('#myCarousel').carousel({
    interval: 4000
});

// handles the carousel thumbnails
$('[id^=carousel-selector-]').click( function(){
  var id_selector = $(this).attr("id");
  var id = id_selector.substr(id_selector.length -1);
  id = parseInt(id);
  $('#myCarousel').carousel(id);
  $('[id^=carousel-selector-]').removeClass('selected');
  $(this).addClass('selected');
});

// when the carousel slides, auto update
$('#myCarousel').on('slid', function (e) {
  var id = $('.item.active').data('slide-number');
  id = parseInt(id);
  $('[id^=carousel-selector-]').removeClass('selected');
  $('[id=carousel-selector-'+id+']').addClass('selected');
});