FactoryGirl.define do
  factory :user do
    name "user"
	email "ex@ample.com"
	email_confirmation "ex@ample.com"
	password "password"
	password_confirmation "password"
  end

end
