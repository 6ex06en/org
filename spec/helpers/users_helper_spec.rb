RSpec.describe UsersHelper, type: :helper do
    
    let(:user) {FactoryGirl.create(:user)}
    let(:user_with_org) {FactoryGirl.create(:user_with_org)}
    
    describe "#has_organization" do
        
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
        
    describe "#no_alone?" do
       
       it "when one user in organization" do
          assign(:current_user, user_with_org)
          expect(helper.no_alone?).to be_falsey
       end
       
       it "when no one user in organization" do
          user.update_attributes(invited: true, organization_id: user_with_org.organization_id)
          assign(:current_user, user_with_org)
          expect(helper.no_alone?).to be_truthy
       end
       
    end
end