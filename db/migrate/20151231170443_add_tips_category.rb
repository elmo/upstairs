class AddTipsCategory < ActiveRecord::Migration
  def change
    Category.create(name: 'Tips', color: '#9714C7')
    c = Category.find_by_name('Tips')
    Post.all.each_with_index {|p,i| p.update_attributes(category_id: c.id) if i % 5 == 0 }
  end
end
