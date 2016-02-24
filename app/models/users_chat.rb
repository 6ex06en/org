class UsersChat < ActiveRecord::Base
  belongs_to :chat
  belongs_to :user
  validates :user_id, :chat_id, presence: true
end
