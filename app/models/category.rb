class Category < ActiveRecord::Base
  has_many :posts
  has_many :categories, foreign_key: 'parent_category_id'
  belongs_to :category, class_name: 'Category', foreign_key: 'parent_category_id'
  scope :root, -> { where(parent_category_id: nil) }
end
