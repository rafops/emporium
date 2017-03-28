FactoryGirl.define do
  factory :upload do
    uuid { SecureRandom.uuid }
    object_key { "uploads/#{uuid}.jpg" }
    name 'photo.jpg'
  end
end
