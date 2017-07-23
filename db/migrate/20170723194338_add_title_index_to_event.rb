class AddTitleIndexToEvent < ActiveRecord::Migration[5.1]
  def change
    add_index :events, 'LOWER(title)', unique: true
  end
end
