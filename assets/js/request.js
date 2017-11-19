module.exports = {
  bind: function() {
    var countCheckmarks = function() {
      return  $(".question-picker input[type=checkbox]:checked").length;
    };

    var showNotification = function(numberOfQuestions) {
      $(".notice").removeClass("invisible");
      $(".notice-message").text("You have selected too many questions: "+ numberOfQuestions);
      $(".request-advice").addClass("disabled").prop("disabled", true);
    };

    var hideNotification = function() {
      $(".notice").addClass("invisible");
      $(".request-advice").removeClass("disabled").prop("disabled", false);
    };

    var notification = function(numberOfQuestions) {
      if ( numberOfQuestions > 5 ) {
        showNotification(numberOfQuestions);
      } else {
        hideNotification();
      }
    };

    $(".question-picker input[type=checkbox]").click(function() {
      var marks = countCheckmarks();
      notification(marks);
    });
  }
}
