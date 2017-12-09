module.exports = {
  bind: function() {
    var state = {
      questions: 0,
      advisors: 0,
      group_lead: 0
    };

    var count = function(group) {
      return $(group + " input:checked").length;
    }

    var showNotification = function(itemName, numberOfQuestions) {
      $(".notice").removeClass("invisible");
      $(".notice-message").text("You have selected too many " +itemName + ": "+ numberOfQuestions);
    };

    var hideNotification = function() {
      $(".notice").addClass("invisible");
    };

    var notification = function() {
      if ( state.questions > 5 ) {
        showNotification("questions", state.questions);
      } else if(state.advisors > 5) {
        showNotification("advisors", state.advisors);
      } else {
        hideNotification();
      }
    };

    var toggleButton = function() {
      var disable = state.advisors > 5
        || state.advisors === 0
        || state.questions > 5
        || state.questions === 0
        || state.group_lead === 0;

      if(disable) {
        $(".request-advice").addClass("disabled").prop("disabled", true);
      } else {
        $(".request-advice").removeClass("disabled").prop("disabled", false);
      }
    }

    $("#group-leads input[type=radio]").click(function() {
      state.group_lead = count("#group-leads");
      notification();
      toggleButton();
    });

    $("#questions input[type=checkbox]").click(function() {
      state.questions = count("#questions");
      notification();
      toggleButton();
    });

    $("#advisors input[type=checkbox]").click(function() {
      state.advisors = count("#advisors");
      notification();
      toggleButton();
    });

    toggleButton();
  }
}
