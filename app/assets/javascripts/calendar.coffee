(($) -> 
 $.fn.test = ->
  a = new Date()
  alert(a.getDate())
  this
) jQuery

currentMonth = (year, month) ->
	current_year = year || new Date().getFullYear()
	current_month = month || new Date().getMonth()
	maxDays = new Date(current_year,current_month+1,0).getDate()
	dayHTML = "<div></div>"
	allDaysHTML = ''
	z = 0
	while maxDays > z
		allDaysHTML = allDaysHTML + dayHTML
		z++
	date = {
		month: new Date().getMonth(),
		days: maxDays,
		html: allDaysHTML
		firstDayofMonth: new Date(current_year, current_month, 1).getDay()
	}
previousMonth = (year, month) ->
	current_year = year || new Date().getFullYear()
	current_month = month || new Date().getMonth()
	previous_month = month || new Date().getMonth() - 1
	# первый день недели в месяце
	firstDayofCurrentMonth = currentMonth().firstDayofMonth
	# кол-во дней в месяце
	maxDays = new Date(current_year,current_month,0).getDate()
	dayHTML = "<div></div>"
	allDaysHTML = ''
	z = 1
	while firstDayofCurrentMonth > z
		allDaysHTML = allDaysHTML + dayHTML
		z++
	firstOfAddedDays = maxDays - firstDayofCurrentMonth + 2
	date = {
		# дни предыдущего месяца, добавленные к календарю
		lastDayOfMonthHTML: allDaysHTML, 
		days: maxDays,
		countAddDays: firstDayofCurrentMonth - 1,
		firstOfAddedDays: firstOfAddedDays
	}

$(document).ready( -> 
	$calendar = $("#container_calendar")
	$calendar.html(currentMonth().html)
	# добавить все дни месяца 
	$calendar.children().each((index) -> 
		$(this).addClass("calendar_day_wrapper col-sm-1 col-md-1").append(document.createElement("div"))
		$(this).children().first().text(index+1).addClass("calendar_day_container text-center")
		)
	if currentMonth().firstDayofMonth > 1
		$calendar.prepend(previousMonth().lastDayOfMonthHTML)
		firstOfAddedDays = previousMonth().firstOfAddedDays
		$calendar.children().each((index) ->
			return false if index == previousMonth().countAddDays
			$(this).addClass("calendar_day_wrapper col-sm-1 col-md-1").append(document.createElement("div"))
			$(this).children().first().text(firstOfAddedDays).addClass("calendar_day_container text-center")
			firstOfAddedDays++
		)
	)
