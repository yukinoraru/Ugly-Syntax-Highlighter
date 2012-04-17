nl2br = (str, is_xhtml) ->
  breakTag = (if (is_xhtml or typeof is_xhtml is "undefined") then "<br />" else "<br>")
  (str + "").replace /([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, "$1" + breakTag + "$2"

rgb2hex = (rgb) ->
  hex = (x) ->
    ("0" + parseInt(x).toString(16)).slice -2
  rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/)
  "#" + hex(rgb[1]) + hex(rgb[2]) + hex(rgb[3])

$ ->
  prettyPrint();

  $("#code").find("span").filter ->
    class_name = $(this).attr("class")
    color      = $("." + class_name).css("color")
    text       = $(this).text()
    $(this).replaceWith( "<font color=" + rgb2hex(color) + ">" + $(this).text(text).html() + "</font>");
