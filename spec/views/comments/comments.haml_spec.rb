require 'rails_helper'

RSpec.describe "comments_views", type: :view do
  let(:admin) {FactoryGirl.create(:admin, invited: true)}
  let(:user_with_org) {FactoryGirl.create(:user_with_org, invited: true, organization_id: admin.organization_id)}
  # let(:user_with_org2) {FactoryGirl.create(:user_with_org, invited: true, organization_id: admin.organization_id)}    
  let!(:task1) {admin.assign_task(user_with_org, "task_name1", date_exec: "2016-08-10")}
  let!(:comment1) {FactoryGirl.create(:comment, task_id: task1.id, commenter: admin.name)}
  let!(:comment2) {FactoryGirl.create(:comment, task_id: task1.id, commenter: admin.name)}

  subject { page }

  describe "page" do
    before do 
      view_daytime_tasks admin
      sleep 1
      click_link(task1.name, :first)
      find(".glyphicon-chevron-down").click
    end

    it "should content destroy_comment and edit_comment links only for last comment", js:true do
      expect(page.all(".destroy_comment", :all).count).to eql 1
      expect(page.all(".edit_comment", :all).count).to eql 1
      expect(page.all(".comments_container ul li:last-child .edit_comment").count).to eql 1
      expect(page.all(".comments_container ul li:last-child .destroy_comment").count).to eql 1
    end
  end
end