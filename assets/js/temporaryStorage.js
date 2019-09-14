import debounce from "debounce";
import {$, all} from './fquery';

export const storage = {
  bind: selector => {
    if (localStorage) {
      all(selector).forEach((answerNode) => {
        let name = answerNode.get('name')

        if (localStorage[name]) {
          answerNode.text = localStorage[name]
        }

        const saveToStorage = () => {
          localStorage[name] = answerNode.value()
        };

        answerNode.on("keyup", debounce(saveToStorage, 300));
      });

      $("#submit-your-advice").on("click", () => {
        localStorage.clear();
      });
    }
  }
};
