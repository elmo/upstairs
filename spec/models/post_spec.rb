require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:category) }
  it { should have_many(:comments) }
  it { should have_many(:notifications) }
  it { should belong_to(:postable) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:category) }

  describe 'creation' do
    before(:each) do
      load_valid_building
      load_user
      @user.join(@building)
      @category = create(:category)
      @valid_attributes = { user: @user, postable: @building, category: @category, title: 'title', body: 'it was a dark and stormy night' }
    end

    it 'creates a post' do
      expect { Post.create(@valid_attributes) }.to change(Post, :count).by(1)
    end

    it 'creates notification' do
      expect { Post.create(@valid_attributes) }.to change(Notification, :count).by(1)
    end

    it 'creates activity event' do
      expect { Post.create(@valid_attributes) }.to change(Activity, :count).by(1)
    end

    describe 'post' do
      before(:each) do
        @post = Post.create(@valid_attributes)
      end

      it 'slug' do
        expect(@post.slug).to eq 'title'
      end

      it 'photos' do
        expect(@post.respond_to?(:photos)).to eq true
      end

      it 'photos' do
        expect(@post.comments).to be_empty
      end

      it 'grandparent' do
        expect(@post.grandparent).to eq @post
      end

      it 'owned_by?' do
        expect(@post.owned_by?(@user)).to eq true
      end

      it 'words' do
        expect(@post.words).to eq %w(it was a dark and stormy night)
      end

      it 'words' do
        expect(@post.word_count).to eq 7
      end

      it 'associates post is whith building' do
        expect(@post.postable).to eq @building
        expect(@post.user).to eq @user
        expect(@building.posts.count).to eq 1
        expect(@building.posts.first).to eq @post
      end
    end
  end
end
