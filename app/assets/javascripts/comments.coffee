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
window.toggle_comment_field = ->
