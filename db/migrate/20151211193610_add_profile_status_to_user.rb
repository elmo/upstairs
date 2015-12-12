class AddProfileStatusToUser < ActiveRecord::Migration
  def change
    add_column :users, :profile_status, :integer, default: 0
    add_index :users, :profile_status, unique: false
  end
end
