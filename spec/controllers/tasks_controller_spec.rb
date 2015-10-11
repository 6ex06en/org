require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  render_views
	let(:admin) {FactoryGirl.create(:admin)}
	let(:user_with_org) {FactoryGirl.create(:user_with_org)}
  let(:task) {admin.assign_task(user_with_org, "task_name")}


  describe "GET #show" do
    before { sign_in admin}
    it "returns http success" do
      xhr :get, :show, {user_id: admin.id, id: task.id}
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET #destroy" do
    before { sign_in admin}
    it "returns http success" do
      xhr :delete, :destroy, {user_id: admin.id, id: task.id}
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET #update" do
    before { sign_in admin}
    it "returns http success" do
      xhr :put, :update, {user_id: admin.id, id: task.id}
      expect(response).to redirect_to(root_path)
    end
  end


  describe "GET #edit" do
    before { sign_in admin}
    it "returns http success" do
      xhr :get, :edit, {user_id: admin.id, id: task.id}
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET #edit" do
    before { sign_in admin}
    it "returns http success" do
      xhr :post, :handle_task, {user_id: admin.id, id: task.id}
      expect(response).to redirect_to(root_path)
    end
  end

  describe "POST #create" do
  	before { sign_in admin}	
  	it "returns http success" do
      post :create, user_id: admin.id, task: {name: "test", executor_id: user_with_org.id, manager_id: admin.id, date_exec: "2015-10-10"}
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end
  end

end
