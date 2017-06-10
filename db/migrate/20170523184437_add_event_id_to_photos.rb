class AddEventIdToPhotos < ActiveRecord::Migration[5.0]
  def change
    add_column :photos, :event_id, :integer
  end
end
