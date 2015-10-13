window.toggle_comments = ->
  height = $(".comments_container ul").outerHeight(true)
  container = $(".comments_container")
  if container.hasClass("hide_comments")
    container.animate({height: "+=#{height}"}, 500)
    container.toggleClass("hide_comments show_comments")
    $(".comments_toggle span").toggleClass("glyphicon-chevron-up glyphicon-chevron-down")
  else
    container.animate({height: "-=#{height + 10}"}, 500)
    container.toggleClass("show_comments hide_comments")
    $(".comments_toggle span").toggleClass("glyphicon-chevron-up glyphicon-chevron-down")
window.comment_field = ->
  if $(".comment_field").hasClass("hidden")
    cont = $(".task_description_body")
    width = cont.width()
    position = cont.offset()
    block = $(".comment_field").draggable()
    $("body").append(block)
    block.find("textarea").focus()
    block.css({
      "min-width": width - (width * 30 / 100) + 'px',
      "left": position.left + 10 + "px",
      "top": position.top + 10 + "px",
      "border-radius": "10px",
      }).toggleClass("visible hidden")
    $(".comment_field span").click ->
      block.toggleClass("visible hidden")
      block.find("textarea").val('')
      cont.append(block)
      $(this).off()
    $(".comment_field input[type='submit']").click ->
      block.toggleClass("visible hidden")
      cont.append(block)
      $(this).off()
