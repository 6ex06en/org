require 'rails_helper'

RSpec.describe News, type: :model do

   it{is_expected.to respond_to(:readed)}
   it{is_expected.to respond_to(:target)}
   it{is_expected.to respond_to(:user)}
   it{is_expected.to respond_to(:reason)}
   let!(:user_with_org) { FactoryGirl.create(:user_with_org) }
   let(:user_from_another_org) { FactoryGirl.create(:user_with_org, organization_id: user_with_org.organization_id + 1) }
   let(:admin) { FactoryGirl.create(:admin, organization_id: user_with_org.organization_id) }
   let!(:task) {admin.assign_task(user_with_org, date_exec: "2016-10-10")}
   let!(:news_due_task) { News.create_news(task, :new_task); News.last}
   let!(:news_due_user) do 
      News.create_news(user_with_org, :new_user) 
      News.last
   end

   it "users should have news when new_user" do 
   	expect(admin.news).to include(news_due_user)
   end

   it "invited user should not have news about new_user" do
   	expect(user_with_org.news).not_to include(news_due_user)
   end

   it "created news should not be readed" do
   	expect(news_due_user.readed).to be_falsey
   end

   it "users should not see user's news from another organization" do
   	expect(user_from_another_org.news).not_to include(news_due_user)
   end

   it "when #read" do
   	expect{news_due_user.read}.to change{news_due_user.readed}.from(false).to(true) 
   end

   xit "news due change task date" do
      News.create_news(news_due_task, :new_task_date_exec)
      expect(new_task_date_exec).to be_valid
   end 

   xit "news due change executor" do
      News.create_news(news_due_task, :new_task_executor)
      expect(new_task_date_exec).to be_valid
   end

   xit "news due user has left organization" do
      News.create_news(news_due_task, :leave_user)
      expect(new_task_date_exec).to be_valid
   end

end
