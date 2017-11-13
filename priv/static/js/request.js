var counter = {numberOfQuestions: 0};

$(document).ready(function() {
  countCheckmarks();
  notification();
});

$(".question-picker ul li input[type=checkbox]").click(function() {
  countCheckmarks();
  notification();
});

function showNotification(numberOfQuestions) {
  $(".notice").removeClass("invisible");
  $("p.notice-message").text("You have selected too many questions: "+ numberOfQuestions);
  $("button.request-advice").addClass("disabled").prop("disabled", true);
}

function hideNotification() {
  $(".notice").addClass("invisible");
  $("button.request-advice").removeClass("disabled").prop("disabled", false);
}

function countCheckmarks() {
  counter.numberOfQuestions = $(".question-picker ul li input[type=checkbox]:checked").length;
}

function notification() {
  if ( counter.numberOfQuestions > 5 ) {
    showNotification(counter.numberOfQuestions);
  } else {
    hideNotification();
  }
}
