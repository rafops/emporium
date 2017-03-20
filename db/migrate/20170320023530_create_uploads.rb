class CreateUploads < ActiveRecord::Migration[5.0]
  def change
    create_table :uploads do |t|
      t.string :object_key, null: false
      t.uuid :uuid, null: false
      t.string :name

      t.timestamps
    end
    add_index :uploads, :uuid, unique: true
  end
end
