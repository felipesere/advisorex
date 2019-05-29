import $ from 'cash-dom';
import debounce from 'debounce';

export const image = {
  from: (fromSelector) => {
    return {
      to: (toSelector) => {
        const changeImage = (event) => $(toSelector).attr("src", event.target.value);

        $(fromSelector).on("keyup", debounce(changeImage, 200));
      }
    }
  }
}
