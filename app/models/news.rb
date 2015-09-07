class News < ActiveRecord::Base
  belongs_to :user

  validates :body, presence:true, length: {maximum: 200}

  def read
  	self.update_attribute(:readed, true)
  end

end
