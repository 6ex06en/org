require 'rails_helper'

RSpec.describe TasksController, type: :controller do
	let(:admin) {FactoryGirl.create(:admin)}
	let(:user_with_org) {FactoryGirl.create(:user_with_org)}


  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  # describe "GET #get_tasks" do
  # 	it "returns http success" do
  # 		sign_in admin
  # 		request.accept = "application/json"
  # 		# {'HTTP_ACCEPT' => "application/json"}
  #     xhr :get, :get_tasks, date: "2015-10-10", format: :json      
  #     expect(response.status).to eql(200)
  #   end
  # end

  describe "POST #create" do
  	before { sign_in admin}	
  	it "returns http success" do
      post :create, user_id: admin.id, task: {name: "test", executor_id: user_with_org.id, manager_id: admin.id, date_exec: "2015-10-10"}
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end

  end

end
