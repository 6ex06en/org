require 'rails_helper'

RSpec.describe "tasks/new.html.haml", type: :view do
  describe "tasks", type: :view, js:true do
  	let(:admin) {FactoryGirl.create(:admin, invited: true)}
	let(:user_with_org) {FactoryGirl.create(:user_with_org, invited: true, organization_id: admin.organization_id)}
  	let!(:task) {admin.assign_task(user_with_org, "task_name", date_exec: "2016-08-10")}
  	let!(:tasks) {Task.collect_tasks("2016-08-10", admin, only_day: true)}
  	let(:user) {FactoryGirl.create(:user, invited: true)}
  	

  	subject { page }
	before do 
		sign_in admin
		visit root_path

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

	# it "when one user in organization" do
	# 	user.create_organization(name: "super")
	# 	sign_out
	# 	visit root_path
	# 	sign_in user
	# 	find("#create_task").click
	# 	is_expected.to have_content("Необходимо пригласить пользователей в организацию")
	# end

	it "show tasks of day" do
		find("#tasks_of_day").click
		expect(page).to have_content("Выполнить до")
	end

	it "when click show task" do
		find("#tasks_of_day").click
		within "#tasks_container" do 
          first(:link, "подробнее").click
        end
     expect(page).to have_css("#task_container")
     expect(page).to have_content(task.name)  
	end

	it "when create task" do
		find("#create_task").click
		fill_in "Имя задачи", with: "test"
		select(user_with_org.name, from: "task_executor_id")

	expect{click_button "Создать"}.to change{admin.tasks_from_me.count}.by(1)
	end

  end
end
