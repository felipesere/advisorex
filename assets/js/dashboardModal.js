import $ from "cash-dom";

export const modal = {
  bind: selector => {
    const toggle = e => {
      $(".modal").toggleClass("is-active");
      $("body").toggleClass("is-active");
    };

    $(selector).on("click", toggle);
    $(".keep").on("click", toggle);
    $(".modal-background").on("click", toggle);

    $(document).on("keyup", event => {
      if ($(".is-active").length > 0 && event.keyCode == 27) {
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
