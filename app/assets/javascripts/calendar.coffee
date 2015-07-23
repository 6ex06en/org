(($) -> 
 $.fn.test = ->
  a = new Date()
  alert(a.getDate())
  this
) jQuery

currentMonth = ->
	current_year = new Date().getFullYear()
	current_month = new Date().getMonth()
	maxDays = new Date(current_year,current_month+1,0).getDate()
	dayHTML = "<div></div>"
	allDaysHTML = ''
	z = 0
	while maxDays > z
		allDaysHTML = allDaysHTML + dayHTML
		z++
	date = {
		month: new Date().getMonth() + 1,
		days: maxDays,
		html: allDaysHTML 
	}

$(document).ready( -> 
	$calendar = $("#container_calendar")
	$calendar.html(currentMonth().html)
	$calendar.children().each((index) ->
		$(this).text(index+1).addClass("calendar_day_container col-sm-1 col-md-1"))
	)
