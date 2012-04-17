nl2br = (str, is_xhtml) ->
  breakTag = (if (is_xhtml or typeof is_xhtml is "undefined") then "<br />" else "<br>")
  (str + "").replace /([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, "$1" + breakTag + "$2"

rgb2hex = (rgb) ->
  hex = (x) ->
    ("0" + parseInt(x).toString(16)).slice -2
  rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/)
  "#" + hex(rgb[1]) + hex(rgb[2]) + hex(rgb[3])

$ ->

  # シンタックスハイライトを有効にする
  prettyPrint();
  $("#code").hide();

  $.each $("#code").find("span"), (i, item) ->
    console.info item
    class_name = $(this).attr("class")
    color      = $("." + class_name).css("color")
    text       = $(this).text()

    if nl2br(text) != text
      text = $(this).text(text).html()
      text = nl2br(text.replace RegExp(" ", "g"), "&nbsp;")
    else
      text = $(this).text(text).html()

    $("#result").append( "<font color=" + rgb2hex(color) + ">" + text + "</font>");
