class AddUuidIndexToEvent < ActiveRecord::Migration[5.1]
  def change
    add_index :events, :uuid, unique: true
  end
end
