module.exports = {
  bind: function(selector) {
    var toggle = function(e) {
      $(".modal").toggleClass("is-active");
    };

    $(selector).click(toggle);
    $(".keep").click(toggle);
    $(".modal-background").click(toggle);

    $(".remove").click(function(e) {
      var questionnaireId = $(this).data("questionnaire");
      fetch("/questionnaire/"+ questionnaireId +"/delete", {credentials: "include"}).then(function(response) {
        if(response.ok) {
          location.reload();
        }
        toggle();
      });
    });
  }
}
