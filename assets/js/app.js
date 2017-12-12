$(document).ready(function() {
  require('js/request.js').bind();
  require('js/temporaryStorage.js').bind('.advice-question textarea');
  require('js/dashboardImage.js').from('.js_user-image-input').to('.js_user-image-display');
  require('js/dashboardModal.js').bind('.delete');
});
