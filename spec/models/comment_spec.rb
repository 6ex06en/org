require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "validates" do
    let(:task) { FactroryGirl.create(:task) }
    let(:comment1) { FactroryGirl.create(:comment) }
    let(:comment2) { FactroryGirl.create(:comment) }
  end
end
