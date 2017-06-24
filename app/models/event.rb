class Event < ApplicationRecord
  has_many :photos, dependent: :delete_all
end
