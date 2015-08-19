require 'rails_helper'

RSpec.describe Task, type: :model do

  it{ is_expected.to respond_to :status}
  it{ is_expected.to respond_to :executor_id}
  it{ is_expected.to respond_to :manager_id}
  it{ is_expected.to respond_to :name}
  it{ is_expected.to respond_to :description}

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
