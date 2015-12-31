class Category < ActiveRecord::Base
  has_many :posts
  has_many :categories, foreign_key: 'parent_category_id'
  belongs_to :category, class_name: 'Category', foreign_key: 'parent_category_id'
  validates_presence_of :name
  validates_presence_of :color
  scope :root, -> { where(parent_category_id: nil) }

  CATEGORY_FOR_SALE = "For Sale"
  CATEGORY_FREE = "Free"
  CATEGORY_HELP_WANTED = "Help Wanted"
  CATEGORY_JOBS_OFFERED = "Jobs Offered"
  CATEGORY_RANDOM = "Random"
  CATEGORY_TIPS = "Tips"


  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  def slug_candidates
    [:name]
  end

  def self.name_list
    [
      CATEGORY_FOR_SALE    , CATEGORY_FREE  , CATEGORY_HELP_WANTED,
      CATEGORY_JOBS_OFFERED, CATEGORY_RANDOM, CATEGORY_TIPS
    ]
  end
end
