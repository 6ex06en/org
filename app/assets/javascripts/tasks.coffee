window.showElements = (elem, context) ->
	self = context
	if $(self).find("input").is(":checked")
		$(".no_task_container").hide()
		$(elem).each( (index,item) ->
			$(item).toggleClass("hidden visible") if $(item).is(".hidden"))
	else
		$(".no_task_container").show()
		$(elem).each( (index,item) ->
			$(item).toggleClass("visible hidden") if $(item).is(".visible"))
