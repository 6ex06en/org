require 'rails_helper'

RSpec.describe News, type: :model do

   it{is_expected.to respond_to(:readed)}
   it{is_expected.to respond_to(:target)}
   it{is_expected.to respond_to(:user)}
   it{is_expected.to respond_to(:reason)}
   let(:user_with_org) { FactoryGirl.create(:user_with_org) }
   let(:admin) { FactoryGirl.create(:admin) }
   let!(:task) {admin.assign_task(user_with_org, date_exec: "2016-10-10")}
   let!(:news_due_task) { News.create_news(task, :new_task)}
   let!(:news_due_user) { News.create_news(user_with_org, :new_user); admin.news.last}

   it "users should have news when new_user" do
   	expect(admin.news).to include(news_due_user)
   end

   it "invited user should not have news about new_user" do
   	expect(user_with_org.news).not_to include(news_due_user)
   end

   it "created news should not be readed" do
   	expect(news_due_user.readed).to be_falsey
   end

   it "name should not be empty" do
   	invalid_news = admin.news_due_user.create
   	expect(invalid_news).not_to be_valid
   end

   it "when #read" do
   	expect{news_due_user.read}.to change{news_due_user.readed}.from(false).to(true) 
   end

end
