window.toggle_comments = ->
  height = $(".comments_container ul").outerHeight(true)
  container = $(".comments_container")
  if container.hasClass("hide_comments")
    container.animate({height: "+=#{height}"}, 500)
    container.toggleClass("hide_comments show_comments")
    $(".comments_toggle span").toggleClass("glyphicon-chevron-up glyphicon-chevron-down")
  else
    container.animate({height: "-=#{height}"}, 500)
    container.toggleClass("show_comments hide_comments")
    $(".comments_toggle span").toggleClass("glyphicon-chevron-up glyphicon-chevron-down")
window.comment_field = ->
  if $(".comment_field").hasClass("hidden")
    cont = $(".task_description_body")
    width = cont.width()
    height = cont.height()
    block = $(".comment_field")
    block.css({
      "min-width": width - 40 + 'px',
      "border-radius": "10px"
      }).toggleClass("visible hidden")
    $(".comment_field span").click ->
      block.find("textarea").empty()
      block.toggleClass("visible hidden")
      $(this).off()

