require 'rails_helper'

RSpec.describe "edit_task", type: :view do
	let(:admin) {FactoryGirl.create(:admin)}
	let(:user_with_org) {FactoryGirl.create(:user_with_org, invited: true, organization_id: admin.organization_id)}	
  let!(:task_from_admin) {admin.assign_task(user_with_org, "task_name", date_exec: "2016-08-10")}
  let!(:task_from_user) {user_with_org.assign_task(admin, "task_name", date_exec: "2016-08-10")}

	describe "day's tasks", js:true do

		subject { page }

		before do 
			view_daytime_tasks admin
		end

		it "only manager should see edit_task link" do
			expect(page).to_not have_selector("#executor_tasks_of_day .edit_task_link")
			expect(page).to have_selector("#manager_tasks_of_day .edit_task_link")
		end

		it "when update task" do
			find("#manager_tasks_of_day .edit_task_link").click
			fill_in "Имя задачи", with: "new_task"
			click_button "Создать"
			expect(page).to have_content("new_task")
		end
	end
end