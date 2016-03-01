require 'rails_helper'

RSpec.describe ChatsController, type: :controller do

  let(:user_with_org) {FactoryGirl.create(:user_with_org)}
  let!(:chat){FactoryGirl.create(:chat, chat_type: "chat", user_id: user_with_org.id)}

  before do
    sign_in user_with_org, no_capybara: true
  end
  
  it "GET index" do
    xhr :get, :index
    expect(subject.current_user).to eql user_with_org
    expect(assigns(:chats)).to include chat
    expect(assigns(:chats)).to eq [chat]
    expect(response).to render_template :index
  end
end
