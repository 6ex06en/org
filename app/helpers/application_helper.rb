module ApplicationHelper
	def title(title)
		base = "Organizer"
		unless title.empty?
			"#{title} | #{base}"
		else
			base
		end
	end
end
