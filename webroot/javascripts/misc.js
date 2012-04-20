(function() {
  var SelectText, nl2br, prettyUgly, rgb2hex;

  $(function() {
    $("#src").bind("textchange", function() {
      console.info("call ugly-prettify func.");
      prettyUgly();
      return $(this).trigger("change.autoResize");
    });
    $("#src").bind("paste", function() {
      return $(this).trigger("change.autoResize");
    });
    $("#src").autoResize({
      maxHeight: 10000,
      animateDuration: 300,
      onAfterResize: function() {
        var newHeight;
        newHeight = $("#src").parent().height();
        $("#dest").parent().height(newHeight);
        return console.info(newHeight);
      },
      animateCallback: function() {
        return $(this).css({
          opacity: 1
        });
      }
    });
    return $("#select-button").click(function() {
      return SelectText("dest");
    });
  });

  prettyUgly = function() {
    $("#working").hide();
    $("#working").text($("#src").val());
    $("#dest").html("");
    prettyPrint();
    return $.each($("#working").find("span"), function(i, item) {
      var class_name, color, text;
      class_name = $(this).attr("class");
      color = $("." + class_name).css("color");
      text = $(this).text();
      if (nl2br(text) !== text) {
        text = $(this).text(text).html();
        text = nl2br(text.replace(RegExp(" ", "g"), "&nbsp;"));
      } else {
        text = $(this).text(text).html();
      }
      return $("#dest").append("<font color=" + rgb2hex(color) + ">" + text + "</font>");
    });
  };

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

  SelectText = function(element) {
    var doc, range, selection, text;
    doc = document;
    text = doc.getElementById(element);
    if (doc.body.createTextRange) {
      range = document.body.createTextRange();
      range.moveToElementText(text);
      return range.select();
    } else if (window.getSelection) {
      selection = window.getSelection();
      range = document.createRange();
      range.selectNodeContents(text);
      selection.removeAllRanges();
      return selection.addRange(range);
    }
  };

}).call(this);
