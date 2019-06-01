import debounce from 'debounce';
import {$} from './fquery';

export const image = {
  from: (fromSelector) => {
    return {
      to: (toSelector) => {
        const changeImage = (event) => $(toSelector).prop("src", event.target.value);

        $(fromSelector).on("keyup", debounce(changeImage, 200));
      }
    }
  }
}
