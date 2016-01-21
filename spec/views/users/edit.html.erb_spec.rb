require 'rails_helper'

RSpec.describe "users/edit.html.erb", type: :view do

  describe "visit page" do
    let(:admin) {FactoryGirl.create(:user_with_org, admin:true)}
    let(:invited_user) {FactoryGirl.create(:user, join_to: admin.organization.id, email: "new@new.ru", 
      email_confirmation: "new@new.ru")}
    let(:user_with_org) {FactoryGirl.create(:user_with_org, organization_id: admin.organization.id)}
    describe "when admin user", js:true do
      
      before do   
       sign_in admin
       visit edit_user_path(admin)
      end

      it "page should contain invite form" do
        # require "pry"; binding.pry       
        expect(page).to have_selector("input#invite_user")
        expect(page).not_to have_selector("input#accept_invitation")
      end
    end

    describe "when the user is invited,", js:true do
      before do
        sign_in invited_user
        visit edit_user_path(invited_user)
      end

      it "user should not ba admin" do
        expect(invited_user.admin).to be_falsey
      end

      it "page should contain accept invitation button" do
        expect(page).to have_selector("input#accept_invitation")
        expect(page).not_to have_selector("input#invite_user")
      end
    end

    describe "tasks," do

      before do   
       sign_in user_with_org
       visit edit_user_path(user_with_org)
      end

      it "when click count of recieved tasks" do
        first(:css, ".task_info_container span:first-child a").click
        expect(page).to have_content("Полученных задач нет")
      end

      it "when click count of assigned tasks" do
        first(:css, ".task_info_container span:last-child a").click
        expect(page).to have_content("Поставленных задач нет")
      end

    end


  end
end
