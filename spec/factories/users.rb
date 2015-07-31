FactoryGirl.define do
  factory :user do
    name "user"
  	email "ex@ample.com"
  	email_confirmation "ex@ample.com"
  	password "password"
  	password_confirmation "password"
    factory :user_with_org do
  	 organization
    end
  end

  factory :organization do
    name "test_org"
  end

end
