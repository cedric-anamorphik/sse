'use strict';

app.directive('textContentParse',['appDataFactory','$compile','_', function(appDataFactory,$compile,_) {
  return {
    restrict: "E",
    replace: true,
    template: '<div></div>',
    scope: {
      rawHtml: '=',
      contentImages: '='
    },
    link: function(scope, elem, attrs) {
      _.forEach(scope.contentImages,function(image) {
        var image_markup = '<img src="' + image.src + '" alt="' + image.alt + '">';
        var image_css = ['content-image','clearfix'];
        if(image.align == 'center') {
          image_css.push(image.align);
        } else {
          image_css.push('pull-' + image.align);
        }
        var styles = 'width:' + image.width + 'px;';
        //var markup = '<div class="' + image_css.join(' ') + '" styles="' + styles + '">' + image_markup + '<div class="caption" styles="' + styles + '">' + image.caption + '</div></div>';
        var markup = '<figure class="' + image_css.join(' ') + '" style="' + styles + '"><div>' + image_markup + '<figcaption class="cf-s12" style="' + styles + '">' + image.caption + '</figcaption></div></figure>'
        scope.rawHtml.replace(image.markup,'ssss');
        var position = scope.rawHtml.indexOf(image.markup);
        scope.rawHtml = [scope.rawHtml.slice(0, position), markup, scope.rawHtml.slice(position)].join('');
      });
      console.log(scope.rawHtml);
      var newElem = $compile(scope.rawHtml)(scope.$parent);
      elem.contents().remove();
      elem.append(newElem);
    }
  };
}]);
