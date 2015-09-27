class News < ActiveRecord::Base
  belongs_to :target, polymorphic: true
  belongs_to :user

  validates :reason, :target_id, :target_type, presence:true, length: {maximum: 200}

  def read
  	self.update_attribute(:readed, true)
  end

  def self.create_news(news_object, reason)
  	if reason == :new_task
  		news_object.news_due_task.create(reason: reason, user_id: news_object.executor.id)
  	elsif reason == :new_user
  		users = news_object.organization.users
  		users.each do |u| 
  			news_object.news_due_user.create(reason: reason, user_id: u.id) unless u == news_object
  		end
  	end
  end

end
