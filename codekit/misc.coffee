$ ->
  $("#src").bind "textchange", ->
    console.info "call ugly-prettify func."
    prettyUgly()
    $(this).trigger("change.autoResize")

  $("#src").bind "paste", ->
    $(this).trigger("change.autoResize")

  $("#src").autoResize
    maxHeight: 10000
    animateDuration: 300
    onAfterResize: ->
      newHeight = $("#src").parent().height()
      $("#dest").parent().height newHeight
      console.info newHeight

    animateCallback: ->
      $(this).css opacity: 1

  # select text
  $("#select-button").click ->
    SelectText "dest"


#################################################
# シンタックスハイライトを有効にする
#################################################
prettyUgly = () ->

  $("#working").hide();
  $("#working").text($("#src").val());
  $("#dest").html "";

  prettyPrint();

  $.each $("#working").find("span"), (i, item) ->
    #console.info item
    class_name = $(this).attr("class")
    color      = $("." + class_name).css("color")
    text       = $(this).text()

    if nl2br(text) != text
      text = $(this).text(text).html()
      text = nl2br(text.replace RegExp(" ", "g"), "&nbsp;")
    else
      text = $(this).text(text).html()

    $("#dest").append( "<font color=" + rgb2hex(color) + ">" + text + "</font>");



nl2br = (str, is_xhtml) ->
  breakTag = (if (is_xhtml or typeof is_xhtml is "undefined") then "<br />" else "<br>")
  (str + "").replace /([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, "$1" + breakTag + "$2"

rgb2hex = (rgb) ->
  hex = (x) ->
    ("0" + parseInt(x).toString(16)).slice -2
  rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/)
  "#" + hex(rgb[1]) + hex(rgb[2]) + hex(rgb[3])

SelectText = (element) ->
  doc = document
  text = doc.getElementById(element)
  if doc.body.createTextRange
    range = document.body.createTextRange()
    range.moveToElementText text
    range.select()
  else if window.getSelection
    selection = window.getSelection()
    range = document.createRange()
    range.selectNodeContents text
    selection.removeAllRanges()
    selection.addRange range

