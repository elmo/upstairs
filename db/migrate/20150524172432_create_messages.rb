class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :sender_id
      t.integer :recipient_id
      t.integer :community_id
      t.text :body
      t.boolean :read, default: false
      t.references :messageble, polymorphic: true, index: true, dependent: :destroy
      t.timestamps null: false
    end
  end
end
