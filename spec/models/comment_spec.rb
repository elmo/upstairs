require 'rails_helper'

RSpec.describe Comment, :type => :model do
  it { should belong_to(:user) }
  it { should belong_to(:comment) }
  it { should have_many(:replies) }
  it { should have_many(:notifications) }
  it { should validate_presence_of(:user)}

  describe "commenting on posts" do
    before(:each) do
      Notification.any_instance.stub(:deliver_later).and_return(true)
      Post.any_instance.stub(:create_notifications).and_return(true)
      load_valid_building
      load_user
      @post = create(:post, user: @user)
    end

    it "creates comment" do
      expect{@post.comments.create(commentable: @post, user: @user)}.to change(Comment,:count).by(1)
    end

    it "commenters" do
      @post.comments.create(commentable: @post, user: @user)
      expect(@post.commenters.first).to eq @user
      expect(@post.comments.count).to eq 1
      expect(@user.comments.count).to eq 1
    end
  end

end
