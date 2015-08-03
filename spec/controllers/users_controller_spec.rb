require 'rails_helper'
require Rails.root.join("spec/support/utilities.rb")

RSpec.describe UsersController, type: :controller do

  let(:user){ FactoryGirl.create(:user)}
  before do
    auth_token = User.new_token
    cookies[:token] = auth_token
    user.update_attribute(:auth_token, User.encrypt(auth_token))
  end

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      get :edit, {id: user.id}
      expect(response).to have_http_status(:success)
    end

    it "returns http redirect" do
      get :edit, {id: user.id+1}
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, {id: user.id}
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #destroy" do
    it "returns http success" do
      get :destroy, {id: user.id}
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #update" do

    it "returns http success" do    
      get :update, {id: user.id}
      expect(response).to have_http_status(:success)
    end
  end

end
