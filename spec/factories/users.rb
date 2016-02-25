FactoryGirl.define do
  
  factory :organization do
    name "test_org"
  end

  factory :task do
    sequence(:name) {|n| "task_name#{n}"}
    date_exec "2016-10-10"
    association :manager, factory: :admin
    association :executor, factory: :user_with_org
  end

  factory :user do
    sequence(:name) {|n| "user#{n}" } 
  	sequence(:email) {|n| "ex_#{n}@ample.com" }
  	sequence(:email_confirmation) {|n| "ex_#{n}@ample.com" }
  	password "password"
  	password_confirmation "password"
      factory :user_with_org do
        organization
        invited true
          factory :admin do
            admin true
            sequence(:email) {|x| "admin_ex#{x}@ample.com" }
            sequence(:email_confirmation) {|x| "admin_ex#{x}@ample.com"}
          end
      end
  end
  
  factory :chat do
    sequence(:name) {|n| "Chat_#{n}"}
    user
  end

end
