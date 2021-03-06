class News < ActiveRecord::Base
  belongs_to :target, polymorphic: true
  belongs_to :user

  validates :reason, :target_id, :target_type, presence:true, length: {maximum: 200}

  def read
  	self.update_attribute(:readed, true)
  end

  def self.create_news(news_object, reason)
  	if reason == :new_task || reason == :task_complete
  		news_object.news_due_task.create(reason: reason, 
        user_id: (reason == :new_task ? news_object.executor.id : news_object.manager.id))
  	elsif reason == :new_user || reason == :leave_organization
  		users = news_object.organization.users
  		users.each do |u| 
  			news_object.news_due_user.create(reason: reason, user_id: u.id) unless u == news_object
  		end      
  	end
  end

end
