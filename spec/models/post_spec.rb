require 'rails_helper'

RSpec.describe Post, :type => :model do
  it { should belong_to(:user) }
  it { should have_many(:comments) }
  it { should belong_to(:postable) }

  describe "creation" do
    before(:each) do
      @building = create(:building)
      @user = create(:user, email: "test1@email.com")
    end

    it "creates a post" do
      expect { Post.create(user: @user, postable: @building ) }.to change(Post,:count).by(1)
    end

    it "does not create a post without a user" do
      expect { Post.create(postable: @building ) }.to change(Post,:count).by(0)
    end

    it "associates post is whith building" do
      @post = Post.create(user: @user, postable: @building )
      expect(@post.postable).to eq @building
      expect(@post.user).to eq @user
      expect(@building.posts.count).to eq 1
      expect(@building.posts.first).to eq @post
    end
  end
end
