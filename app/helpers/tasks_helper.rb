module TasksHelper

	def all_archived?(tasks)
		archived = tasks.select{|t| t.status == "archived"}
		archived.count == tasks.count
	end
end
