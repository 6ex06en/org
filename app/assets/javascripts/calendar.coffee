(($) -> 
 $.fn.test = ->
  a = new Date()
  alert(a.getDate())
  this
) jQuery


Calendar = (year,month) ->
	current_year = year || new Date().getFullYear()
	current_month = month || new Date().getMonth()
	previous_month = current_month - 1
	next_month = current_month + 1
	dayHTML = "<div></div>"
	@currentMonth = () ->
		maxDays = new Date(current_year,next_month,0).getDate()
		allDaysHTML = ''
		z = 0
		while maxDays > z
			allDaysHTML = allDaysHTML + dayHTML
			z++
		date = {
			days: maxDays,
			html: allDaysHTML
			firstDayofMonth: new Date(current_year, current_month, 1).getDay()
		}
	@previousMonth = () ->
		allDaysHTML = ''
		maxDays = new Date(current_year,current_month,0).getDate()
		firstDayofCurrentMonth = @currentMonth().firstDayofMonth	# первый день недели в месяце
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
	@nextMonth = (classCSS) ->
		needAddDays = 7-((@previousMonth().countAddDays + @currentMonth().days) % 7)
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
	return
calendar = new Calendar()

$(document).ready( -> 
	$calendar = $("#container_calendar")
	$calendar.html(calendar.currentMonth().html)
	# добавить все дни текущего месяца 
	$calendar.children().each((index) -> 
		$(this).addClass("calendar_day_wrapper col-sm-1 col-md-1").append(document.createElement("div"))
		$(this).children().first().text(index+1).addClass("calendar_day_container text-center")
		)
	#добавление дней предыдущего месяца
	if calendar.currentMonth().firstDayofMonth > 1
		$calendar.prepend(calendar.previousMonth().lastDayOfMonthHTML)
		firstOfAddedDays = calendar.previousMonth().firstOfAddedDays
		$calendar.children().each((index) ->
			return false if index == calendar.previousMonth().countAddDays
			$(this).addClass("calendar_day_wrapper col-sm-1 col-md-1 pr").append(document.createElement("div"))
			$(this).children().first().text(firstOfAddedDays).addClass("calendar_day_container text-center")
			firstOfAddedDays++
		)
	#добавлениее разделителей строк bootstrap
	count = 0
	$calendar.children().each((index) ->
		count++
		if count == 7		
			$(this).after($("<div/>", {class: "col-md-5 col-md-5 col-g-5"}))
			$(this).next().after($("<div/>", {class: "clearfix visible-sm-block visible-md-block visible-lg-block"}))
			count = 0
		)
	#добавление дней со следующего месяца 
	$calendar.append(calendar.nextMonth("next").html)
	$calendar.children(".next").addClass("calendar_day_wrapper col-sm-1 col-md-1").each((index) ->
		$(this).append($("<div/>", {class: "calendar_day_container text-center", text: index+1 }))
		)
)
$(document).ready( -> 
	$(".calendar_day_wrapper").mouseenter( ()->
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
