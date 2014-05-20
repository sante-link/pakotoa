FactoryGirl.define do
  factory :certificate_authority do
    sequence(:name) { |n| "Authority ##{n}" }
    sequence(:basename) { |n| "authority_#{n}" }
  end
end
