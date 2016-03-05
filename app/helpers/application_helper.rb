module ApplicationHelper
	def title(title)
		base = "Organizer"
		unless title.empty?
			"#{title} | #{base}"
		else
			base
		end
	end

	def load_script script, options = {}
 		result = content_tag :script, nil, src: asset_path(script)
		result << content_tag(:script, options[:execute].html_safe) if options[:execute]
	end

end
