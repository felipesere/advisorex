module.exports = {
  bind: function(selector) {
    if(localStorage) {
      $(selector).each(function(idx, answer) {
        let answerNode = $(answer)

        if(localStorage[answer.name]) {
          answerNode.text(localStorage[answer.name]);
        }

        answerNode.change(function() {
          localStorage[answer.name] = answerNode.val();
        });
      });

      $('button[type=submit]').click(function() {
        localStorage.clear();
      });
    }
  }
}
