require 'rails_helper'

RSpec.describe Organization, type: :model do

	describe Organization do

		
		let(:organization) {FactoryGirl.create(:organization)}
		let(:user) {FactoryGirl.create(:user, organization: organization)}

		it {is_expected.to respond_to(:name)}
		it {is_expected.to respond_to(:users)}

		it "when #users" do
			expect(organization.users).to include(user)
			expect(user.organization.name).to eq "test_org" 
		end
	end
end
