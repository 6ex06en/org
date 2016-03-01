RSpec.describe UsersHelper, type: :helper do
    
    describe "#has_organization" do
        
        let(:user) {FactoryGirl.create(:user)}
        
        it "when has_organization" do
            assign(:current_user, user)
            expect(helper.has_organization?).to be_falsey
        end
        
        it "when has no organization" do
            user.create_organization(name: "test")
            assign(:current_user, user)
            expect(helper.has_organization?).to be_truthy
        end
    end
end