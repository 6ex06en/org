require 'rails_helper'

RSpec.describe ChatsController, type: :controller do

  let(:user_with_org) {FactoryGirl.create(:user_with_org)}
  let!(:chat){FactoryGirl.create(:chat, user_id: user_with_org.id)}

  before do
    sign_in user_with_org
  end

  describe "GET index" do
    get :chats
    expect(assigns(:chat)).to include chat
  end
end
