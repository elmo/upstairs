require 'rails_helper'

RSpec.describe Category, type: :model do
  it { should have_many(:posts) }
  it { should belong_to(:category) }
  it { should have_many(:categories) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:color) }

  describe "constants" do
    it "CATEGORY_FOR_SALE" do
      expect(Category::CATEGORY_FOR_SALE).to eq 'For Sale'
    end

    it "CATEGORY_FREE" do
      expect(Category::CATEGORY_FREE).to eq 'Free'
    end

    it "CATEGORY_HELP_WANTED" do
      expect(Category::CATEGORY_HELP_WANTED).to eq 'Help Wanted'
    end

    it "CATEGORY_JOBS_OFFERED" do
      expect(Category::CATEGORY_JOBS_OFFERED).to eq 'Jobs Offered'
    end

    it "CATEGORY_RANDOM" do
      expect(Category::CATEGORY_RANDOM).to eq 'Random'
    end

    it "CATEGORY_TIPS" do
      expect(Category::CATEGORY_TIPS).to eq 'Tips'
    end

    it "name_list" do
      expect(Category.name_list).to eq [
        Category::CATEGORY_FOR_SALE,
        Category::CATEGORY_FREE,
        Category::CATEGORY_HELP_WANTED,
        Category::CATEGORY_JOBS_OFFERED,
        Category::CATEGORY_RANDOM,
        Category::CATEGORY_TIPS
      ]
    end
  end

  describe 'Category' do
    it 'creates' do
      expect { Category.create(name: 'Books', color: 'red') }.to change(Category, :count).by(1)
    end

    it 'creates child category' do
      @category = create(:category)
      expect { Category.create(name: 'Books', color: 'pink', parent_category_id: @category.id) }.to change(Category, :count).by(1)
    end

    it 'parent/child category' do
      @category = create(:category)
      @child_category = Category.create(name: 'Books', color: 'pink', category: @category)
      expect(@child_category.category).to eq @category
      expect(@category.categories.first).to eq @child_category
      expect(Category.count).to eq 2
      expect(Category.root.count).to eq 1
    end
  end
end
