FactoryGirl.define do
  factory :application, class: Doorkeeper::Application do
    name 'Test Application'
    redirect_uri 'urn:ietf:wg:oauth:2.0:oob'
  end
end
