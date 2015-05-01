class AddSlugToClassified < ActiveRecord::Migration
  def change
    add_column :classifieds, :slug, :string
  end
end
