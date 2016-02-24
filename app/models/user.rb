class User < ActiveRecord::Base
	belongs_to :organization
	has_many :tasks_from_me, class_name: "Task", foreign_key: "manager_id", dependent: :destroy
	has_many :tasks_to_me, class_name: "Task", foreign_key: "executor_id"
	has_many :assigned_tasks, through: :tasks_from_me, source: :executor
	has_many :news
	has_many :news_due_user, as: :target, class_name: "News", dependent: :destroy
  has_one  :option, dependent: :destroy
	has_many :chats_relationships, class_name: "UsersChat", foreign_key: "user_id"
	has_many :chats, through: :chats_relationships
	validates :name, length: { minimum: 3, maximum: 20 }
	validates :email, presence: true, confirmation: true, uniqueness: { case_sensitive: false }
	validates :password, length: {minimum: 8}, on: :create
	validates :email_confirmation, :password_confirmation, presence: true, on: :create
	has_secure_password
	before_create :create_auth_token

def User.new_token
	SecureRandom.urlsafe_base64
end

def User.encrypt(token)
	Digest::SHA1.hexdigest(token.to_s)
end

def invited?
	self.invited
end

def assign_task(user, task_name, obj= {})
	tasks_from_me.create(executor_id: user.id, name: task_name, date_exec: obj[:date_exec], description: obj[:description],
		status: (obj[:status]) ? obj[:status] : "ready")
end

def User.create_invitation(user, inviter)
	user.update_attribute(:join_to, inviter.organization.id)
end

def tasks
	Task.where("executor_id = ? OR manager_id = ?", self.id, self.id)
end

def clean_tasks
  tasks = Task.includes(:manager, :executor).where("manager_id = :id OR executor_id = :id", id: self.id)
  	.references(:user).preload(:news_due_task)
  tasks.each do |task|
  	task.destroy if task.manager.organization_id == self.organization_id || task.executor.organization_id == self.organization_id
  end
  self
end

def active_tasks_from_me
  tasks_from_me.where("tasks.status IS NOT 'archived'")
end

def active_tasks_to_me
  tasks_to_me.where("tasks.status IS NOT 'archived'")
end

def join_chat(chat_id)
	UsersChat.create!(user_id: self.id, chat_id: chat_id)
end

private

def create_auth_token
	self.auth_token = User.encrypt(User.new_token)
end

end
