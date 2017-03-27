class Upload < ApplicationRecord

  validates :object_key, presence: true
  validates :uuid, presence: true, uniqueness: true

end
