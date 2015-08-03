require "rails_helper"

RSpec.describe Main, type: :mailer do
  describe "join_to_organization" do
    let!(:user) {FactoryGirl.create(:user)}
    let!(:inviter) {FactoryGirl.create(:user_with_org, email: "other@mail.com", email_confirmation: "other@mail.com")}
    let(:mail) { Main.join_to_organization(user, inviter)}

    it "renders the headers" do
      expect(mail.subject).to eq("Organizer")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

  end

end
