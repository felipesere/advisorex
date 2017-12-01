var debounce = require('debounce');

module.exports = {
  from: function(fromSelector) {
    return {
      to: function(toSelector) {
        var changeImage = function(event) {
          $(toSelector).attr("src", event.target.value);
        };

        $(fromSelector).keyup(debounce(changeImage, 200));
      }
    }
  }
}
