require 'rails_helper'

RSpec.describe "users/edit.html.erb", type: :view do

  describe "visit page" do
    let(:admin) {FactoryGirl.create(:user_with_org, admin:true)}
    let(:invite_key) {User.encrypt(User.new_token)}
    let(:user_with_invite_key) {FactoryGirl.create(:user, invite_key: User.encrypt(User.new_token), email: "new@new.ru", 
      email_confirmation: "new@new.ru")}
    describe "when admin user", js:true do
      
      before do   
       sign_in admin
       visit edit_user_path(admin)
      end

      it "page should contain invite form" do       
        expect(page).to have_selector("input#invite_user")
        expect(page).not_to have_selector("input#accept_invitation")
      end
    end

    describe "when the user is invited,", js:true do
      before do
        sign_in user_with_invite_key
        visit edit_user_path(user_with_invite_key)
      end

      it "user should not ba admin" do
        expect(user_with_invite_key.admin).to be_falsey
      end

      it "page should contain accept invitation button" do
        expect(page).to have_selector("input#accept_invitation")
        expect(page).not_to have_selector("input#invite_user")
      end
    end


  end
end
