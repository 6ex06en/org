FactoryGirl.define do
  
  factory :organization do
    name "test_org"
  end

  factory :task do
    name "first"  
  end

  factory :user do
    sequence(:name) {|n| "user#{n}" } 
  	sequence(:email) {|n| "ex_#{n}@ample.com" }
  	sequence(:email_confirmation) {|n| "ex_#{n}@ample.com" }
  	password "password"
  	password_confirmation "password"
      factory :user_with_org do
        organization
          factory :admin do
            admin true
            sequence(:email) {|x| "admin_ex#{x}@ample.com" }
            sequence(:email_confirmation) {|x| "admin_ex#{x}@ample.com"}
          end
      end
  end

end
