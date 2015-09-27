require 'rails_helper'

RSpec.describe "main_pages news" do

	let(:admin) {FactoryGirl.create(:admin)}
	let(:user_with_org) { FactoryGirl.create(:user_with_org)}
	let!(:task) {admin.assign_task(user_with_org, "task_name1", date_exec: "2016-08-10")}

	subject {page}

	before { sign_in user_with_org}

end