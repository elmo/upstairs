class AddColorToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :color, :string
    Category.where(name: 'For Sale').update_all(color: '#09B34A')
    Category.where(name: 'Free').update_all(color: '#9611D9')
    Category.where(name: 'Help Wanted').update_all(color: '#193DE0')
    Category.where(name: 'Jobs Offered').update_all(color: '#CBD10D')
    Category.where(name: 'Random').update_all(color: '#E87676')
  end
end
