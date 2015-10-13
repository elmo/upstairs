module CategoriesHelper
  def category_list
    Category.root.collect { |x| [x.name, x.id] }
  end
end
