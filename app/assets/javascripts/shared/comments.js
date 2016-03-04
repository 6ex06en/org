// Generated by CoffeeScript 1.9.2
window.toggle_comments = function() {
  var container, height;
  height = $(".comments_container ul").outerHeight(true);
  container = $(".comments_container");
  if (container.hasClass("hide_comments")) {
    container.animate({
      height: "+=" + height
    }, 500);
    container.toggleClass("hide_comments show_comments");
    return $(".comments_toggle span").toggleClass("glyphicon-chevron-up glyphicon-chevron-down");
  } else {
    container.animate({
      height: "-=" + height
    }, 500);
    container.toggleClass("show_comments hide_comments");
    return $(".comments_toggle span").toggleClass("glyphicon-chevron-up glyphicon-chevron-down");
  }
};

window.comment_field = function() {
  var block, cont, height, width;
  if ($(".comment_field").hasClass("hidden")) {
    cont = $(".task_description_body");
    width = cont.width();
    height = cont.height();
    block = $(".comment_field");
    block.css({
      "min-width": width + 'px',
      "border-radius": "10px"
    }).toggleClass("visible hidden");
    return $(".comment_field span").click(function() {
      block.find("textarea").empty();
      block.toggleClass("visible hidden");
      return $(this).off();
    });
  }
};