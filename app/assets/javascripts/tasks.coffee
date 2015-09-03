window.showElements = (elem, context) ->
	self = context
	if $(self).find("input").is(":checked")
		$(".pagination_wrapper").toggleClass("hidden visible")
		$(".pagination_wrapper_checked").toggleClass("hidden visible")
		$(".no_task_container").addClass("hidden")
		$(elem).toggleClass("hidden visible")
	else
		$(".pagination_wrapper").toggleClass("visible hidden")
		$(".pagination_wrapper_checked").toggleClass("visible hidden")
		$(elem).toggleClass("visible hidden")
		$(".no_task_container").removeClass("hidden")
