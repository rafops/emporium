class AddParentUuidToUploads < ActiveRecord::Migration[5.0]
  def change
    add_column :uploads, :parent_uuid, :uuid
    add_index :uploads, :parent_uuid
  end
end
