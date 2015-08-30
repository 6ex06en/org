window.showElements = (elem, context) ->
	self = context
	if $(self).find("input").is(":checked")
		$(elem).each( (index,item) ->
			$(item).toggleClass("hidden visible") if $(item).is(".hidden"))
	else
		$(elem).each( (index,item) ->
			$(item).toggleClass("visible hidden") if $(item).is(".visible"))