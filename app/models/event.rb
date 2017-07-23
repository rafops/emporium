class Event < ApplicationRecord

  has_many :photos, dependent: :delete_all
  before_save :set_uuid
  scope :where_title_like, -> (title) { where('LOWER(title) LIKE ?', "%#{title.downcase}%") }
  scope :entitled, -> (title) { where('LOWER(title) = ?', title.downcase) }

  private
  
    def set_uuid
      return unless self.uuid.nil?
      self.uuid = SecureRandom.uuid
    end

end
