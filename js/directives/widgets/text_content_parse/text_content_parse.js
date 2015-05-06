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
      if(scope.contentImages.length > 0) {
        _.forEach(scope.contentImages,function(image) {
          var image_css = ['content-image','clearfix'];
          if(_.has(image,'class')) { image_css.push(image.class); }
          if(image.align == 'center') {
            image_css.push(image.align);
          } else {
            image_css.push('pull-' + image.align);
          }
          var styles = '';
          if(_.has(image,'width')) {
            styles = 'style="max-width:' + image.width + 'px;"';
          }

          if(_.has(image,'src') && !_.has(image,'width')) {
            var img_obj = new Image();
            var width, height;
            img_obj.onload = function() {
              width = this.width;
              height = this.height;
            }
            img_obj.src = image.src;
            styles = 'style="max-width:' + img_obj.width + 'px;"';
          }

          var markup = '';
          if(_.has(image,'class') && image.class == 'quote') {
            markup = '<div class="pull-quote clearfix">';
            var repattern = '"';
            var refind = new RegExp(repattern,'g');
            markup += '<div class="col-10"><figcaption class="cf-s16 pull-left">' + image.caption.replace(refind,"") + '</figcaption></div>';
            markup += '<div class="col-2"><figure class="' + image_css.join(' ') + '" ' + styles + '><img src="' + image.src + '" alt="' + image.alt + '"></figure></div>';
            markup += '</div>';
          } else if(_.has(image,'embed')) {
            markup = '<iframe width="' + image.width + '" height="' + image.height + '" src="' + image.embed + '" frameborder="0" allowfullscreen></iframe>';
          } else {
            var image_markup = '<img src="' + image.src + '" alt="' + image.alt + '">';
            //var markup = '<div class="' + image_css.join(' ') + '" styles="' + styles + '">' + image_markup + '<div class="caption" styles="' + styles + '">' + image.caption + '</div></div>';
            if(_.has(image,'align') && image.align == 'center') { styles = ''; }
            markup = '<figure class="' + image_css.join(' ') + '" ' + styles + '><div class="image-wrapper">' + image_markup + '</div>';
            if(_.has(image,'caption')) { markup += '<figcaption class="cf-s12" ' + styles + '">' + image.caption + '</figcaption>'; }
            markup += '</figure>';
          }
          var position = scope.rawHtml.indexOf(image.markup);
          scope.rawHtml = [scope.rawHtml.slice(0, position), markup, scope.rawHtml.slice(position)].join('');
        });
      }

      //var newElem = $compile(scope.rawHtml)(scope.$parent);
      elem.contents().remove();
      //elem.append(newElem);
      elem.append(scope.rawHtml);
    }
  };
}]);
