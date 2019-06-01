import {$, all} from './fquery';

let state = {
  questions: 0,
  advisors: 0,
  mentor: 0
};

const count = (group) => document.querySelectorAll(group + " input:checked").length;

const showNotification = (itemName, numberOfQuestions) => {
  $(".notice").remove("invisible");
  $(".notice-message").text = `You have selected too many ${itemName} : ${numberOfQuestions}`;
};

const hideNotification = () => $(".notice").add("invisible");

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

  const advice = $("#ask-for-advice")

  if(disable) {
    advice.add("disabled");
    advice.disabled(true);
  } else {
    advice.remove("disabled");
    advice.disabled(false);
  }
}

export const request = {
  bind: function() {
    all("#mentors input[type=radio]", "click", () => {
      state.mentor = count("#mentors");
      notification();
      toggleButton();
    });

    all("#questions input[type=checkbox]", "click", () => {
      state.questions = count("#questions");
      notification();
      toggleButton();
    });

    all("#advisors input[type=checkbox]", "click", () => {
      state.advisors = count("#advisors");
      notification();
      toggleButton();
    });

    toggleButton();
  }
}
