class News < ActiveRecord::Base
  belongs_to :object, polymorphic: true

  validates :body, presence:true, length: {maximum: 200}

  def read
  	self.update_attribute(:readed, true)
  end

  def self.create_task(news_object, options={})
  	if options[:new_task]
  		news_object.executor.tasks.create(body: "#{news_object.manager.name} назначил Вам)
  	end
  end

end
