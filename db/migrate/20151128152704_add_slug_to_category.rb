class AddSlugToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :slug, :string
    add_index(:categories, :slug, unique: true)
    Category.all.map(&:save)
  end
end
