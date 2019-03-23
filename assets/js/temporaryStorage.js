import $ from "cash-dom";
import debounce from "debounce";

export const storage = {
  bind: selector => {
    if (localStorage) {
      $(selector).each((idx, answer) => {
        const answerNode = $(answer);

        if (localStorage[answer.name]) {
          answerNode.text(localStorage[answer.name]);
        }

        const saveToStorage = () =>
          (localStorage[answer.name] = answerNode.val());

        answerNode.on("keyup", debounce(saveToStorage, 300));
      });

      $("button[type=submit]").on("click", () => {
        localStorage.clear();
      });
    }
  }
};
