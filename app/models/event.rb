class Event < ApplicationRecord
  has_many :photos, dependant: :delete_all
end
