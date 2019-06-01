import {$} from './fquery';

export const modal = {
  bind: selector => {
    const toggle = e => {
      $(".modal").toggle("is-active");
      $("body").toggle("is-active");
    };

    $(selector).on("click", toggle);
    $(".keep").on("click", toggle);
    $(".modal-background").on("click", toggle);

    document.addEventListener("keyup", event => {
      if ($(".is-active").present && event.keyCode == 27) {
        toggle();
      }
    });

    $(".remove").on("click", e => {
      const questionnaireId = $(".remove").data("questionnaire");

      fetch("/questionnaire/" + questionnaireId + "/delete", {
        credentials: "include"
      }).then(response => {
        if (response.ok) {
          location.reload();
        }
        toggle();
      });
    });
  }
};
