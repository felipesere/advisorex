import debounce from "debounce";
import {$, grab} from './fquery';

export const storage = {
  bind: selector => {
    if (localStorage) {
      grab(selector).forEach((answerNode) => {
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
