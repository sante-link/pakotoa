FactoryGirl.define do
  factory :authority do
    sequence(:name) { |n| "Authority ##{n}" }
    sequence(:basename) { |n| "authority_#{n}" }
  end
end
