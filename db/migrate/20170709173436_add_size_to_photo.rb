class AddSizeToPhoto < ActiveRecord::Migration[5.1]
  def change
    add_column :photos, :size, :integer
  end
end
