class Comment < ActiveRecord::Base
  belongs_to :task
  validates :comment, presence: true, length: {maximum: 500}
  validates :commenter, presence: true
end
