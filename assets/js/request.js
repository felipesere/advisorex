import $ from 'cash-dom';

let state = {
  questions: 0,
  advisors: 0,
  mentor: 0
};

const count = (group) => $(group + " input:checked").length;

const showNotification = (itemName, numberOfQuestions) => {
  $(".notice").removeClass("invisible");
  $(".notice-message").text("You have selected too many " +itemName + ": "+ numberOfQuestions);
};

const hideNotification = () => $(".notice").addClass("invisible");

const notification = () => {
  if ( state.questions > 5 ) {
    showNotification("questions", state.questions);
  } else if(state.advisors > 5) {
    showNotification("advisors", state.advisors);
  } else {
    hideNotification();
  }
};

const toggleButton = () => {
  const disable = state.advisors > 5
    || state.advisors === 0
    || state.questions > 5
    || state.questions === 0
    || state.mentor === 0;

  if(disable) {
    $(".request-advice").addClass("disabled").prop("disabled", true);
  } else {
    $(".request-advice").removeClass("disabled").prop("disabled", false);
  }
}

export const request = {
  bind: function() {
    $("#mentors input[type=radio]").on("click", () => {
      state.mentor = count("#mentors");
      notification();
      toggleButton();
    });

    $("#questions input[type=checkbox]").on("click", () => {
      state.questions = count("#questions");
      notification();
      toggleButton();
    });

    $("#advisors input[type=checkbox]").on("click", () => {
      state.advisors = count("#advisors");
      notification();
      toggleButton();
    });

    toggleButton();
  }
}
