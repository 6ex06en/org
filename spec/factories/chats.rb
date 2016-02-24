FactoryGirl.define do
  factory :chat do
    sequence(:name) {|n| "Chat_#{n}"}
  end

end
