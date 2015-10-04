require 'rails_helper'

RSpec.describe "main_pages news" do

	let(:admin) {FactoryGirl.create(:admin)}
	let(:user_with_org) { FactoryGirl.create(:user_with_org)}
	let!(:task) {admin.assign_task(user_with_org, "task_name1", date_exec: "2016-08-10")}

	subject {page}

  describe "when new task" do

    before do 
      News.create_news(task, :new_task)
      sign_in user_with_org
    end

    it "render new_task news" do 
      expect(page).to have_content("Вам назначили новую задачу")
    end

  end

end