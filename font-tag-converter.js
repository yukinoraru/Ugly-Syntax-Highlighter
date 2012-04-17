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
    $("#code").hide();
    return $.each($("#code").find("span"), function(i, item) {
      var class_name, color, text;
      console.info(item);
      class_name = $(this).attr("class");
      color = $("." + class_name).css("color");
      text = $(this).text();
      if (nl2br(text) !== text) {
        text = $(this).text(text).html();
        text = nl2br(text.replace(RegExp(" ", "g"), "&nbsp;"));
      } else {
        text = $(this).text(text).html();
      }
      return $("#result").append("<font color=" + rgb2hex(color) + ">" + text + "</font>");
    });
  });

}).call(this);
