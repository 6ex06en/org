require 'rails_helper'

RSpec.describe "tasks/index", type: :view do
  describe "filter_tasks", type: :view do
  	let(:admin) {FactoryGirl.create(:admin, invited: true)}
  	let(:user_with_org) {FactoryGirl.create(:user_with_org, invited: true, organization_id: admin.organization_id)}
	let(:user_with_org2) {FactoryGirl.create(:user_with_org, invited: true, organization_id: admin.organization_id)}		
  	let!(:task) {admin.assign_task(user_with_org, "task_name1", date_exec: "2016-08-10")}
  	let!(:task2) {admin.assign_task(user_with_org2, "task_name2", date_exec: "2016-08-10", status: "pause")}
  	let!(:task3) {user_with_org.assign_task(admin, "task_name3", date_exec: "2016-08-11", status: "archived")}
  	let!(:task4) {user_with_org2.assign_task(admin, "task_name4", date_exec: "2016-08-14", status: "complete")}
  	let!(:tasks) {Task.collect_tasks("2016-08-10", admin, only_day: true)}

  	subject { page }

  			describe "click all tasks and filter", js:true do
			before do
				view_daytime_tasks admin

		    	click_link("Все задачи")
		    	click_link("Отфильтровать")
		    end

		    it "by manager" do
		    	select("Менеджер", from: "task_your_status")
		    	click_button("Отправить")
		    	expect(page).to have_content(task.name)
		    	expect(page).not_to have_content(task3.name)
		    end

		    it "by executor" do
		    	select("Исполнитель", from: "task_your_status")
		    	click_button("Отправить")
		    	expect(page).to have_content(task3.name)
		    	expect(page).not_to have_content(task.name)
		    end

		    it "by start_date" do
		    	fill_in "Начиная с:", with:"2016-08-11"
		    	click_button("Отправить")
		    	expect(page).to have_content(task3.name)
		    	expect(page).not_to have_content(task2.name)
		    end

		    it "by end_date" do
		    	fill_in "Заканчивая до:", with: "2016-08-12"
		    	click_button("Отправить")
		    	expect(page).to have_content(task.name)
		    	expect(page).not_to have_content(task4.name)
		    end

		    it "by task name" do
		    	fill_in "Название задачи:", with: task.name
		    	click_button("Отправить")
		    	expect(page).to have_content(task.name)
		    end

		    it "by task status" do
		    	select "Не выполняется", from: "filter_task_status"
		    	click_button("Отправить")
		    	expect(page).to have_content(task.name)
		    	expect(page).not_to have_content(task2.name)
		    	expect(page).not_to have_content(task3.name)
		    	expect(page).not_to have_content(task4.name)
		    end
		end
  end
end