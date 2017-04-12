$.register({
  rule: {
    host: [
      /^openload\.co$/,
      /^oload\.tv$/,
    ],
    path: /^\/f\/.*/,
  },
  start: function (m) {
    $.window.adblock = false;
    $.window.adblock2 = false;
    $.window.popAdsLoaded = true;
  },
  ready: function () {
    'use strict';

    setTimeout(function () {
      var clip = function (u) {
        GM_setClipboard(u);

        var title = (function () {
          var meta = document.querySelector('meta[name="description"]');
          return meta !== null ? meta.content : window.location.pathname.split('/').pop().split('#')[0].split('?')[0];
        })();

        GM_notification(
          'Direct download link stored in clipboard',
          title,
          'https://openload.co/favicon.ico'
        );
      };

      var timer = $('#downloadTimer');
      timer.style.display = 'none';

      var dlCtn = $('#realdl');
      dlCtn.style.display = 'inline-block';

      var dlBtn = $('a', dlCtn);
      var ePath = $('#streamurl');
      dlBtn.href = "/stream/" + ePath.textContent;

      var videoCtn = $.$('.videocontainer');

      if (videoCtn) {
        var overlay = $('#videooverlay', videoCtn);
        overlay.click();

        // use iframe instead of $.openLink
        // in order to not affect streaming
        dlBtn.addEventListener('click', function (evt) {
          evt.preventDefault();

          // TODO *iframe* hack is not normal
          // please generalize in the future
          var iframe = document.createElement('iframe');
          iframe.src = dlBtn.href;
          document.body.appendChild(iframe);
        });

        _.info(_.T('{0} -> {1}')(window.location, dlBtn.href));

        clip(dlBtn.href);
      } else {
        clip(dlBtn.href);
      }
    }, 500);
  }
});
