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

	describe "when login manager", js:true do

		let(:user_with_org) {FactoryGirl.create(:user_with_org, invited: true, organization_id: admin.organization_id)}
		let(:user_with_org2) {FactoryGirl.create(:user_with_org, invited: true, organization_id: admin.organization_id)}		
  		let!(:task) {admin.assign_task(user_with_org, "task_name1", date_exec: "2016-08-10")}
  		let!(:task2) {admin.assign_task(user_with_org2, "task_name2", date_exec: "2016-08-10")}
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
			find("#create_task").click
			fill_in "Имя задачи", with: "test"
			select(user_with_org.name, from: "input_task_executor")
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
		     	is_expected.not_to have_selector('input[type="submit"][value="Начать"]')
		     end
		end

	end

	describe "when login executor", js:true do

		let(:user_with_org) {FactoryGirl.create(:user_with_org, invited: true, organization_id: admin.organization_id)}	
  		let!(:task) {admin.assign_task(user_with_org, "task_name", date_exec: "2016-08-10")}
  		let!(:tasks) {Task.collect_tasks("2016-08-10", admin, only_day: true)}
  		
		before do 
			view_daytime_tasks user_with_org
		end

		it {is_expected.to_not have_css("#day_tasks .destroy_task_link")}

		describe "click show task", js:true do
			before do
				within "#day_tasks" do 
		          first(:link, "task_name").click
		        end
	    	end

		     it "should not be button accept task" do
		     	expect(page).to have_selector('input[type="submit"][value="Начать"]')
		     end

		     it "should not be button accept task" do
		     	within "#handle_task_form" do
		     		first(".handler_button_container input").click
		     	end
		     	expect(page).to have_selector('input[type="submit"][value="Приостановить"]')

		     	within "#handle_task_form" do
		     		first(".handler_button_container input").click
		     	end
		     	expect(page).to have_selector('input[type="submit"][value="Возобновить"]')
		     end
		end
	end

  end
end
