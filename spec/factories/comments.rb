FactoryGirl.define do
  factory :comment do
    task    
    sequence(:comment) {|n|  "MyString_#{n}" }
    commenter "user1"
  end

end
