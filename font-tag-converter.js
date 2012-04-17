(function() {
  var nl2br, rgb2hex;

  nl2br = function(str, is_xhtml) {
    var breakTag;
    breakTag = (is_xhtml || typeof is_xhtml === "undefined" ? "<br />" : "<br>");
    return (str + "").replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, "$1" + breakTag + "$2");
  };

  rgb2hex = function(rgb) {
    var hex;
    hex = function(x) {
      return ("0" + parseInt(x).toString(16)).slice(-2);
    };
    rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
    return "#" + hex(rgb[1]) + hex(rgb[2]) + hex(rgb[3]);
  };

  $(function() {
    prettyPrint();
    return $("#code").find("span").filter(function() {
      var class_name, color, text;
      class_name = $(this).attr("class");
      color = $("." + class_name).css("color");
      text = $(this).text();
      return $(this).replaceWith("<font color=" + rgb2hex(color) + ">" + $(this).text(text).html() + "</font>");
    });
  });

}).call(this);
