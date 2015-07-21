class User < ActiveRecord::Base
	validates :name, presence: true, length: { minimum: 3, maximum: 20 }
	validates :email, presence: true, confirmation: true, uniqueness: { case_sensitive: false }
	validates :password, length: {minimum: 8}, confirmation: true
	validates :email_confirmation, :password_confirmation, presence: true
	has_secure_password
end
