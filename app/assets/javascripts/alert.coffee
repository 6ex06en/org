window.fadeFlash = ->
  $(".alert-success").fadeOut(2500)
  $(".alert-danger").fadeOut(2500)
$(document).ready( ->
	setTimeout(->
		$(".flash-list").fadeOut(2500)
	,1000)
	)