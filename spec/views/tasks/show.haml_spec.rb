require 'rails_helper'

RSpec.describe "tasks/show.html.haml", type: :view do
  describe "tasks", type: :view do
  	let(:admin) {FactoryGirl.create(:admin, invited: true)}
  	let(:user) {FactoryGirl.create(:user, invited: true)}
  	

  	subject { page }


	describe "when one user in organization", js: true do
			before do 
			sign_in admin

			find(".dropdown-togle-month").click

			within ".dropmenu-month" do
				find(".list-month:nth-child(8)").click
			end

			find(".dropdown-togle-year").click
			all(".list-year")[1].click

			within "#container_calendar" do 
	          find(".calendar_day_wrapper:nth-child(10)").click
	        end

	        find("#create_task").click
		end
		
		it{is_expected.to have_content("Необходимо пригласить пользователей в организацию")}
	end

	describe "when no one user in organization", js:true do

		let(:user_with_org) {FactoryGirl.create(:user_with_org, invited: true, organization_id: admin.organization_id)}	
  		let!(:task) {admin.assign_task(user_with_org, "task_name", date_exec: "2016-08-10")}
  		let!(:tasks) {Task.collect_tasks("2016-08-10", admin, only_day: true)}
  		
		before do 
			sign_in admin

			find(".dropdown-togle-month").click

			within ".dropmenu-month" do
				find(".list-month:nth-child(8)").click
			end

			find(".dropdown-togle-year").click
			all(".list-year")[1].click

			within "#container_calendar" do 
	          find(".calendar_day_wrapper:nth-child(10)").click
	        end
		end

		it "show tasks of day" do
			find("#tasks_of_day").click
			expect(page).to have_content("Выполнить до")
		end

		it "when click destroy task" do
			find("#tasks_of_day").click
			within "#day_tasks" do 
	          first(".destroy_task_link").click
	          page.driver.browser.switch_to.alert.accept
	        end
	     expect(page).to have_css("#day_tasks")
	     expect(page).not_to have_content(task.name)  
		end

		it "when create task" do
			@date = "2016-08-10".to_date.strftime("%FT%R")
			find("#create_task").click
			fill_in "Имя задачи", with: "test"
			select(user_with_org.name, from: "task_executor_id")
			find(".create_task_button").click

			expect(page).to have_content("test")
		end

		describe "when click show task", js:true do
			before do
				find("#tasks_of_day").click
				within "#day_tasks" do 
		          first(:link, "task_name").click
		        end
	    	end

		     it {expect(page).to have_css("#task_container")}
		     it {expect(page).to have_content(task.name)}

		     it "should not be button accept task" do
		     	expect(page).not_to have_button("Начать")
		     end		     
		end

	end

  end
end
