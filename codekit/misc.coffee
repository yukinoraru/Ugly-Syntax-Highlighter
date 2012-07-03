#################################################
# 言語とクラスの対応表
# 以下のようなRubyでのワンライナーから作る
# (open("prettify_test.html").read + open("prettify_test_2.html").read).scan(/<h1>([\w \+\/\(\)\-#]+)<\/h1>/).sort.uniq.each{|lang| puts lang}
# (open("prettify_test.html").read + open("prettify_test_2.html").read).scan(/lang-[a-zA-Z]+/).sort.uniq
#################################################
languages = [
  {name: "Auto", class: ""},
  {name: "Bash", class: "lang-sh"},
  {name: "C", class: "lang-c"},
  {name: "C#", class: "lang-cs"},
  {name: "C++", class: "lang-cc"},
  {name: "Clojure", class: "lang-clj"},
  {name: "Coffeescript", class: "lang-coffee"},
  {name: "CSS", class: "lang-css"},
  {name: "F#", class: "lang-ml"},
  {name: "Go", class: "lang-go"},
  {name: "Haskell", class: "lang-hs"},
  {name: "HTML", class: "lang-html"},
  {name: "Java", class: "lang-java"},
  {name: "Javascript", class: "lang-js"},
  {name: "Lisp", class: "lang-el"},
  {name: "Lua", class: "lang-lua"},
  {name: "Nemerle", class: "lang-nemerle"},
  {name: "OCaml", class: "lang-ml"},
  {name: "Perl", class: "" },
  {name: "PHP", class: "" },
  {name: "Protocol Buffers", class: "lang-proto"},
  {name: "Python", class: "lang-py"},
  {name: "Ruby", class: "" },
  {name: "Scala", class: "lang-scala"},
  {name: "SQL", class: "lang-sql"},
  {name: "TeX", class: "lang-tex"},
  {name: "VBScript", class: "lang-vb"},
  {name: "VHDL", class: "lang-vhdl"},
  {name: "Whitespace", class: "" },
  {name: "Wiki", class: "lang-wiki"},
  {name: "XHTML", class: "" },
  {name: "XML", class: "" },
  {name: "XQuery", class: "lang-xq"},
  {name: "XSL", class: "" },
  {name: "YAML", class: "lang-yaml"},
]

#################################################
# イベントの設定
#################################################
$ ->
  $("#src").bind "textchange", ->
    prettyUglify()

  $("#src").autoResize
    maxHeight: 10000
    animateDuration: 300
    onAfterResize: ->
      newHeight = $("#src").parent().height()
      $("#dest").parent().height newHeight
    animateCallback: ->
      $(this).css opacity: 1

  # テキストを選択する
  $("#select-button").click ->
    select_text "dest"

  # シンタックスハイライトを再度適用
  $("#showLineNumber").click ->
    prettyUglify()

  # シンタックスハイライトの言語を追加しておく
  $("#langSelect").append("<option>" + lang["name"] + "</option>") for lang in languages

  # 言語を指定する
  $("#langSelect").change ->
    selectedIndex = $("#langSelect :selected").index()
    console.log selectedIndex
    $("#working").removeClass();
    $("#working").addClass("prettyprint");
    $("#working").addClass(languages[selectedIndex]["class"]);

  #
  $("#featured").orbit()

#################################################
# シンタックスハイライトを有効にする
#################################################
prettyUglify = () ->

  #$("#working").show();

  # add line number
  src = $("#src").val()
  if $("#showLineNumber").is(":checked")
   tmp = ""
   $.each src.split("\n"), (i, item) ->
     tmp += i + ": " + item + "\n"
   src = tmp

  $("#working").text(src);

  $("#dest").html "";

  # google code prettify
  prettyPrint();

  $.each $("#working").find("span"), (i, item) ->
    #console.info item
    class_name = $(this).attr("class")
    color      = $("." + class_name).css("color")
    text       = expand_tab($(this).text())

    if nl2br(text) != text
      #console.info("nl2br:"+text.replace RegExp(" ", "g"), "&nbsp;")
      text = nl2br(text.replace RegExp(" ", "g"), "&nbsp;")
    else
      #console.info("raw:"+text)
      text = $(this).text(text).html()
      text = text.replace RegExp(" ", "g"), "&nbsp;"

    $("#dest").append( "<font color=" + rgb2hex(color) + ">" + text + "</font>");


#################################################
# 各種関数群
#################################################

expand_tab = (text, n = 4) ->
  repeat = (pattern, count) ->
    return ""  if count < 1
    result = ""
    while count > 0
      result += pattern  if count & 1
      count >>= 1
      pattern += pattern
    result
  return text.replace RegExp("\t", "g"), repeat("&nbsp;", n)

nl2br = (str, is_xhtml) ->
  breakTag = (if (is_xhtml or typeof is_xhtml is "undefined") then "<br />" else "<br>")
  (str + "").replace /([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, "$1" + breakTag + "$2"

rgb2hex = (rgb) ->
  hex = (x) ->
    ("0" + parseInt(x).toString(16)).slice -2
  rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/)
  "#" + hex(rgb[1]) + hex(rgb[2]) + hex(rgb[3])

count_nl = (str) ->
  try
    return (str.match(RegExp("([^>\r\n]?)(\r\n|\n\r|\r|\n)", "g")).length)
  catch e
    return 0

select_text = (element) ->
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

