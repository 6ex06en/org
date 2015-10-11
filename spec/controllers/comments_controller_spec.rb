require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  render_views
  let!(:admin) {FactoryGirl.create(:admin)}
  let(:user_with_org) {FactoryGirl.create(:user_with_org)}
  let(:task) {admin.assign_task(user_with_org, "task_name")}

  describe "POST #create" do
    before { sign_in admin}
    it "returns http success" do
      xhr :post, :create, task_id: task.id, comment: {comment: "dfdf", commenter: "User"}
      expect(response).to have_http_status(:redirect)
    end
  end

end
