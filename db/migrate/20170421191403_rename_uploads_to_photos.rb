class RenameUploadsToPhotos < ActiveRecord::Migration[5.0]
  def self.up
    rename_table :uploads, :photos
  end

  def self.down
    rename_table :photos, :uploads
  end
end
