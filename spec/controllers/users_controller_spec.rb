require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      get :edit, {id: 1}
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, {id: 1}
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #create" do
    it "returns http success" do
      get :create, {id: 1}
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #destroy" do
    it "returns http success" do
      get :destroy, {id: 1}
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #update" do
    it "returns http success" do
      get :update, {id: 1}
      expect(response).to have_http_status(:success)
    end
  end

end
