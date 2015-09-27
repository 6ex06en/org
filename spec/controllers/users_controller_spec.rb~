require 'rails_helper'
require Rails.root.join("spec/support/utilities.rb")

RSpec.describe UsersController, type: :controller do

  let(:user){ FactoryGirl.create(:user)}
  before do
    sign_in user, no_capybara:true
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

    it "returns http redirect if the user page of another users" do
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

  describe "GET #destroy_invitation" do
    it "returns http success" do
      get :destroy_invitation, {id: user.id}
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(edit_user_path(user))
    end
  end


end
