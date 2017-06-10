class RemoveEventIdToPhotos < ActiveRecord::Migration[5.0]
  def change
    remove_column :photos, :event_id, :integer
  end
end
