FactoryGirl.define do
  factory :user, class: User do
    sequence :name do |n|
      "user_#{n}"
    end
  end
end