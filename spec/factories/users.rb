FactoryGirl.define do
  
  factory :organization do
    name "test_org"
  end

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

end
