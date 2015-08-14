require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
  render_views
  let(:admin) {FactoryGirl.create(:admin)}
  let!(:user) {FactoryGirl.create(:user)}
  let(:organization) { FactoryGirl(:organization)}

  describe "GET #create" do
    before { sign_in user}
    it "returns http success" do
      post :create, oragnization: {name: "test"}
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to("/")
    end
  end

    describe "DELETE #destroy" do
      before {sign_in admin}
      it "returns http success" do
        delete :destroy, {id: admin.organization.id}
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to("/")
      end
    end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #invite_user", js: true do
    before do 
      sign_in admin
      visit edit_user_path(admin)
      fill_in "Email", with: user.email
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end

  # describe "GET #show" do
  #   it "returns http success" do
  #     get :show
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "GET #new" do
  #   it "returns http success" do
  #     get :new
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "GET #edit" do
  #   it "returns http success" do
  #     get :edit
  #     expect(response).to have_http_status(:success)
  #   end
  # end

end
