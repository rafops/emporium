class AddUuidToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :uuid, :uuid, null: false
  end
end
