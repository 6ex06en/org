require 'rails_helper'

RSpec.describe Task, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  describe "Task" do
  	let(:user) { FactoryGirl.create(:user)}
  	let(:admin) { FactoryGirl.create(:admin)}
  	let!(:task) { Task.create(name: "first", manager_id: admin.id, executor_id: user.id)}

	it "should have date_exec" do		
		expect(task.date_exec).not_to be_nil
		expect(task.date_exec).to eq task.created_at
	end

  end
end
