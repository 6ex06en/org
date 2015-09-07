require 'rails_helper'

RSpec.describe News, type: :model do

   it{is_expected.to respond_to(:readed)}
   it{is_expected.to respond_to(:object)}
   it{is_expected.to respond_to(:reason)}
   let(:user) { FactoryGirl.create(:user) }
   let(:user_news) { user.news.create(body: "It's first news")}

   it "user should have news" do
   	expect(user.news).to include(user_news)
   end

   it "created news should not be readed" do
   	expect(user_news.readed).to be_falsey
   end

   it "name should not be empty" do
   	invalid_news = user.news.create
   	expect(invalid_news).not_to be_valid
   end

   it "when #read" do
   	expect{user_news.read}.to change{user_news.readed}.from(false).to(true) 
   end

end
