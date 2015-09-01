window.showElements = (elem, context) ->
	self = context
	if $(self).find("input").is(":checked")
		$(".no_task_container").addClass("hidden")
		$(".pagination_wrapper").toggleClass("hidden visible")
		$(".pagination_wrapper_checked").toggleClass("hidden visible")
		$(elem).each( (index,item) ->
			$(item).toggleClass("hidden visible") if $(item).is(".hidden"))
	else
		$(".pagination_wrapper").toggleClass("visible hidden")
		$(".pagination_wrapper_checked").toggleClass("visible hidden")
		$(".no_task_container").removeClass("hidden")
		$(elem).each( (index,item) ->
			$(item).toggleClass("visible hidden") if $(item).is(".visible"))
