import {$, all} from './fquery';

const findNodeWith = (element, expectedAttribute) => {
  while(element) {
    if (element.getAttribute(expectedAttribute)) {
      break;
    }
    element = element.parentElement;
  }

  return element
}

const toggle = e => {
  $(".modal").toggle("modal--active");
  $("body").toggle("hidden-overflow");
};

export const modal = {
  bind: selector => {

    all(selector).forEach((node) => {
      node.on('click', (e) => {
        let element = findNodeWith(e.target, "data-questionnaire-id")

        const questionnaireId = element.getAttribute("data-questionnaire-id");
        const mentee = element.getAttribute("data-mentee-name");

        $('#modal-title').text = `Confirm for ${mentee}`

        toggle()

        $(".remove").on("click", () => {
          fetch(`/questionnaire/${questionnaireId}/delete`, { credentials: "include" }).then(response => {
            if (response.ok) {
              location.reload()
            }
          });
        })
      });
    })

    $(".keep").on("click", toggle);
    $(".modal-background").on("click", toggle);

    $(document).on("keyup", (event) => {
      if ($(".modal--active").present && event.keyCode == 27) {
        toggle();
      }
    });
  }
};

