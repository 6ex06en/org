class Chat < ActiveRecord::Base
  before_create :create_relationship_with_user
  belongs_to :user

  validates :name, presence: true

  private

    def create_relationship_with_user

    end
end
