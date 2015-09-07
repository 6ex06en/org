class User < ActiveRecord::Base
	belongs_to :organization
	has_many :tasks_from_me, class_name: "Task", foreign_key: "manager_id", dependent: :destroy
	has_many :tasks_to_me, class_name: "Task", foreign_key: "executor_id"
	has_many :assigned_tasks, through: :tasks_from_me, source: :executor
	has_many :tasks, through: :tasks_to_me, source: :manager
	has_many :news, dependent: :destroy
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

private

def create_auth_token
	self.auth_token = User.encrypt(User.new_token)
end

end

