class AddUsernameToUser < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_column :users, :phone, :string
    add_column :users, :use_my_username, :boolean, default: true
    add_column :users, :ok_to_send_text_messages, :boolean, default: true
  end
end
