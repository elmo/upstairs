require 'rails_helper'

RSpec.describe Category, type: :model do
  it { should have_many(:posts) }
  it { should belong_to(:category) }
  it { should have_many(:categories) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:color) }

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
