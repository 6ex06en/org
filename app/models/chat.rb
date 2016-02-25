class Chat < ActiveRecord::Base
  after_create :create_relationship_with_user
  belongs_to :user

  validates :name, :chat_type, :user_id, presence: true
  validates :chat_type, inclusion: {in: %w(private chat)}

  private

    def create_relationship_with_user
      UsersChat.create!(user_id: self.user_id, chat_id: self.id)
    end
end
