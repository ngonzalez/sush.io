FactoryGirl.define do
  factory :repository, class: Repository do
    association :user, factory: :user
    name { Faker::Company.buzzword.gsub(' ', '-') }
    remote_id { Faker::Number.number(5) }
    remote_created_at { Faker::Date.between(10.years.ago, 1.week.ago) }
  end
end