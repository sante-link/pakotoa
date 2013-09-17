FactoryGirl.define do
  factory :authority do
    sequence(:name) { |n| "Authority ##{n}" }
  end
end
