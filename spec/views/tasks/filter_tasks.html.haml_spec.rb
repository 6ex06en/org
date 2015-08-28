require 'rails_helper'

RSpec.describe "tasks/index", type: :view do
  describe "filter_tasks", type: :view do
  	let(:admin) {FactoryGirl.create(:admin, invited: true)}
  	let(:user_with_org) {FactoryGirl.create(:user_with_org, invited: true, organization_id: admin.organization_id)}
	let(:user_with_org2) {FactoryGirl.create(:user_with_org, invited: true, organization_id: admin.organization_id)}		
  	let!(:task) {admin.assign_task(user_with_org, "task_name", date_exec: "2016-08-10")}
  	let!(:task2) {admin.assign_task(user_with_org2, "task_name2", date_exec: "2016-08-10")}
  	let!(:tasks) {Task.collect_tasks("2016-08-10", admin, only_day: true)}

  	subject { page }

  			describe "click all tasks" , js:true do
			before do
				view_daytime_tasks admin

		    	# within "#buttons_container" do 
		     #      first(:link, "all_tasks").click
		    	# end
		    	click_link("Все задачи")
		    	click_link("Отфильтровать")
		    end

		    it "and filter by executor" do
		    	select("Менеджер", from: "task_your_status")
		    	click_button("Отправить")
		    	pending "should be tasks only one user"
		    end

		    it "and filter by date" do
		    	select("2015", from: "tasks_date_exec_start_1i")
		    	click_button("Отправить")
		    	pending "should not be tasks only within chosen date"

		    	select("2016", from: "tasks_date_exec_start_1i")
		    	click_button("Отправить")
		    	pending "should be tasks only within chosen date"
		    end

		    it "and filter by task name" do
		    	fill_in "Название задачи:", with: task.name
		    	click_button("Отправить")
		    	pending "should be tasks only with chosen name"
		    end

		    it "and filter by task status" do
		    	select "Не выполняется", from: "filter_task_status"
		    	click_button("Отправить")
		    	pending "should be tasks only with chosen name"
		    end
		end
  end
end