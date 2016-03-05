require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ChatsHelper. For example:
#
# describe ChatsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ChatsHelper, type: :helper do
  let(:user1) {FactoryGirl.create(:user_with_org)}
  let(:user2) {FactoryGirl.create(:user_with_org, organization_id: user1.organization_id)}

  describe "#organization_users" do

    it "without argumets" do
      assign(:current_user, user2)
      expect(helper.organization_users).to contain_exactly(user1, user2)
    end

    it "with :without_me params" do
      assign(:current_user, user2)
      expect(helper.organization_users(:without_me)).to contain_exactly(user1)
    end
  end
end
