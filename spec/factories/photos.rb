FactoryGirl.define do
  factory :photo do
    uuid { SecureRandom.uuid }
    object_key { "photos/#{uuid}.jpg" }
    name 'photo.jpg'
  end
end
