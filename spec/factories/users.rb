FactoryGirl.define do
  factory :user do
    email { "#{SecureRandom.urlsafe_base64}@example.com" }
    password { 'password' }
    confirmed_at { Time.now.utc }
  end
end
