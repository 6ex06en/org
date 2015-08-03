require "rails_helper"

RSpec.describe Main, type: :mailer do
  describe "join_to_organization" do
    let(:mail) { Main.join_to_organization }

    it "renders the headers" do
      expect(mail.subject).to eq("Join to organization")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
