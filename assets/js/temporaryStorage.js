var debounce = require('debounce');

module.exports = {
  bind: function(selector) {
    if(localStorage) {
      $(selector).each(function(idx, answer) {
        let answerNode = $(answer)

        if(localStorage[answer.name]) {
          answerNode.text(localStorage[answer.name]);
        }

        var saveToStorage = function() {
          localStorage[answer.name] = answerNode.val();
        };

        answerNode.keyup(debounce(saveToStorage, 300));
      });

      $('button[type=submit]').click(function() {
        localStorage.clear();
      });
    }
  }
}
