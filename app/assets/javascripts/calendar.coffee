
calendar = (obj) -> # январь - 1
	month = obj.month || new Date().getMonth() + 1
	year = obj.year || new Date().getFullYear()
	container = $(obj.container) if obj.container # куда будет помещен календарь

	current_year = year
	current_month = month - 1 # январь - 0
	previous_month = current_month - 1
	next_month = current_month + 1
	dayHTML = "<div></div>"
	currentMonth = () ->
		maxDays = new Date(current_year,next_month,0).getDate()
		firstDayofMonth = new Date(current_year, current_month, 1).getDay()
		firstDayofMonth = 7 if firstDayofMonth == 0 # воскреенье - 7, а не 0
		allDaysHTML = ''
		z = 0
		while maxDays > z
			allDaysHTML = allDaysHTML + dayHTML
			z++
		date = {
			month: current_month
			year: current_year
			days: maxDays,
			html: allDaysHTML
			firstDayofMonth: firstDayofMonth
		}

	previousMonth = (classCSS) ->
		allDaysHTML = ''
		dayHTML = "<div class='#{classCSS}'></div>" if classCSS
		maxDays = new Date(current_year,current_month,0).getDate()
		firstDayofCurrentMonth = currentMonth().firstDayofMonth	# первый день недели в месяце
		firstOfAddedDays = maxDays - firstDayofCurrentMonth + 2	
		z = 1
		while firstDayofCurrentMonth > z
			allDaysHTML = allDaysHTML + dayHTML
			z++	
		date = {			
			lastDayOfMonthHTML: allDaysHTML, # дни предыдущего месяца, добавленные к календарю
			days: maxDays,
			countAddDays: firstDayofCurrentMonth - 1,
			firstOfAddedDays: firstOfAddedDays
		}
	nextMonth = (classCSS) ->
		needAddDays = 7-((previousMonth().countAddDays + currentMonth().days) % 7)
		needAddDays = 0 if needAddDays == 7
		allDaysHTML = ''
		dayHTML = "<div class='#{classCSS}'></div>" if classCSS
		z = 0
		while needAddDays > z
			allDaysHTML = allDaysHTML + dayHTML
			z++
		date = {
			needAddDays: needAddDays,
			html: allDaysHTML
		}
	buildCalendar = () ->
		$calendar = container || $("#container_calendar")
		$calendar.html(currentMonth().html)
		# добавить все дни текущего месяца 
		$calendar.children().each((index) -> 
			$(this).addClass("calendar_day_wrapper col-xs-1 col-sm-1 col-md-1 col-lg-1").append(document.createElement("div"))
			$(this).children().first().text(index+1).addClass("calendar_day_container text-center").attr("data-day-cur", index+1)
			)
		#добавление дней предыдущего месяца
		if currentMonth().firstDayofMonth > 1
			countAddDays = previousMonth().countAddDays
			$calendar.prepend(previousMonth().lastDayOfMonthHTML)
			firstOfAddedDays = previousMonth().firstOfAddedDays
			$calendar.children().each((index) ->
				return false if index == countAddDays
				$(this).addClass("calendar_day_wrapper col-xs-1 col-sm-1 col-md-1 col-lg-1 pr").append(document.createElement("div"))
				$(this).children().first().text(firstOfAddedDays).addClass("calendar_day_container text-center")
				$(this).children().first().attr("data-day-pr", firstOfAddedDays)
				firstOfAddedDays++
			)
		#добавление дней со следующего месяца 
		$calendar.append(nextMonth("next").html)
		$calendar.children(".next").addClass("calendar_day_wrapper col-xs-1 col-sm-1 col-md-1 col-lg-1").each((index) ->
			$(this).append($("<div/>", {class: "calendar_day_container text-center", text: index+1, "data-Day-Next": index+1 }))
		)
		#установка в заголовке название месяца и год
		month = $(".dropmenu-month").children()[current_month]
		$(".dropdown-togle-month").text(month.textContent+" ").attr("mn", current_month+1).append("<span class='caret'></span>")
		$(".dropdown-togle-year").text(current_year+" ").append("<span class='caret'></span>")
		
		#обработчик на заголовке
		$(".list-month").click( ->
			calendar(month: $(this).index()+1)()
			)
		$(".list-year").click( ->
			calendar({month: $(".dropdown-togle-month").attr("mn"), year: $(this).text()})()
			)

		$(document).ready( -> 
			#эффект увеличения дня месяца
			$(".calendar_day_wrapper").click( ()->
				$offset = $(this).offset()
				$div_clone = $(this).clone()
				$(this).parent().append($div_clone)
				$div_clone.css({"position":"absolute"}).offset((i,val) ->
					{left: $offset.left - 15, top: $offset.top - 15}).width((i,val) ->
						val + 30).addClass("clone")
				$div_clone.mouseleave( ()->
					$(this).remove()
				)
			)
		)

$(document).ready( () ->
	 calendar({})()

)

