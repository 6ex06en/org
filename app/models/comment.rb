class Comment < ActiveRecord::Base
  belongs_to :task
  validates :comment, :commenter, presence: true, length: {maximum: 500}
end
