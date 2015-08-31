require 'rails_helper'

RSpec.describe "all_tasks", type: :view, js:true do

		let(:admin) {FactoryGirl.create(:admin, invited: true)}
		let(:user_with_org) {FactoryGirl.create(:user_with_org, invited: true, organization_id: admin.organization_id)}
		let(:user_with_org2) {FactoryGirl.create(:user_with_org, invited: true, organization_id: admin.organization_id)}		
  		let!(:task) {admin.assign_task(user_with_org, "task_name", date_exec: "2016-08-10")}
  		let!(:task2) {admin.assign_task(user_with_org2, "task_name2", date_exec: "2016-08-11")}
  		let!(:archived_task) {admin.assign_task(user_with_org2, "archived_task", date_exec: "2016-08-10")}
  		let!(:task_for_admin) {user_with_org.assign_task(admin, "task_for_admin", date_exec: "2016-08-15")}
  		let!(:tasks) {Task.collect_tasks("2016-08-10", admin, only_day: true)}

	subject { page }

	describe "sent task" do
		before do
			archived_task.update_attributes(:status => "archived")
			view_daytime_tasks admin
			click_link("Все задачи")			
		end

		it "should be only sent tasks whithout archived_task" do
			expect(page).to have_content(task.name)
			expect(page).to have_content(task2.name)
			expect(page).not_to have_content(archived_task.name)
		end

		it "should be only sent tasks whith archived_task" do
			find(".check_box_archived_tasks input").click
			expect(page).to have_content(task.name)
			expect(page).to have_content(task2.name)
			expect(page).to have_content(archived_task.name)
		end

		it "should not be recieved tasks" do
			expect(page).not_to have_content(task_for_admin.name)
		end
	end

	describe "recieved task" do
		before do
			view_daytime_tasks admin
			click_link("Все задачи")
			click_link("Полученные задачи")
		end

		it "should be only recieved tasks" do
			expect(page).to have_content(task_for_admin.name)
		end

		it "should not be recieved tasks" do
			expect(page).not_to have_content(task.name)
		end
	end

end