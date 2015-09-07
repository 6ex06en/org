class News < ActiveRecord::Base
  belongs_to :target, polymorphic: true
  belongs_to :user

  validates :reason, :target_id, :target_type, presence:true, length: {maximum: 200}

  def read
  	self.update_attribute(:readed, true)
  end

  def self.create_news(news_object, reason)
  	if reason == :new_task
  		news_object.news_due_task.create(reason: reason, user_id: news_object.manager.id)
  	end
  end

end
