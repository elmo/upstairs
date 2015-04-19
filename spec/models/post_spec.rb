require 'rails_helper'

RSpec.describe Post, :type => :model do
  it { should belong_to(:user) }
  it { should have_many(:comments) }
  it { should belong_to(:postable) }

  describe "creation" do
    before(:each) do
      @community = create(:community)
      @user = create(:user, email: "test1@email.com")
    end

    it "creates a post" do
      expect { Post.create(user: @user, postable: @community ) }.to change(Post,:count).by(1)
    end

    it "does not create a post without a user" do
      expect { Post.create(postable: @community ) }.to change(Post,:count).by(0)
    end

    it "associates post is whith community" do
      @post = Post.create(user: @user, postable: @community )
      expect(@post.postable).to eq @community
      expect(@post.user).to eq @user
      expect(@community.posts.count).to eq 1
      expect(@community.posts.first).to eq @post
    end
  end
end
