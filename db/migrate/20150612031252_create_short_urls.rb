class CreateShortUrls < ActiveRecord::Migration
  def change
    create_table :short_urls do |t|
      t.string :token
      t.string :url
      t.timestamps null: false
    end
    add_index(:short_urls, :token)
  end
end
