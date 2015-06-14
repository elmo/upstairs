require 'rails_helper'

RSpec.describe Comment, :type => :model do
  it { should belong_to(:user) }
  it { should belong_to(:user) }
  it { should have_many(:replies) }

  before(:each) do
    @building = create(:building)
    @user = create(:user, email: "user1@user.com")
    @post = create(:post, user: @user, postable: @building)
  end

  it "creates a comment" do
    @commenter  = create(:user, email: "commenter@email.com" )
    expect { Comment.create(commentable: @post, user: @commenter) }.to change(Comment,:count).by(1)
  end

  #it "creates and actionable" do
  #  @commenter  = create(:user, email: "commenter@email.com" )
  #  expect { Comment.create(commentable: @post, user: @commenter) }.to change(Activty,:count).by(1)
  #end

  it "does not create a comment with out user" do
    expect { Comment.create(commentable: @post) }.to change(Comment,:count).by(0)
  end

  it "associates comment with post" do
    @commenter  = create(:user, email: "commenter@email.com" )
    @comment = Comment.create(commentable: @post, user: @commenter)
    expect(@comment.commentable).to eq @post
    expect(@post.comments.count).to eq 1
    expect(@post.comments.first).to eq @comment
    expect(@post.user).to eq @user
    expect(@building.comments.size).to eq 1
  end

  describe "reply" do
    before(:each) do
      @commenter  = create(:user, email: "commenter@email.com" )
      @comment = Comment.create(commentable: @post, user: @commenter)
    end

    it "associates a reply with a comment" do
     @replier = create(:user, email: "replier@email.com" )
     expect { @reply = create(:reply, user: @replier , parent_comment_id: @comment.id) }.to change(Comment, :count).by(1)
    end

    it "associates a reply with a comment" do
      @replier = create(:user, email: "replier@email.com" )
      @reply = create(:reply, user: @replier , parent_comment_id: @comment.id)
      expect(@reply.comment).to eq @comment
      expect(@reply.user).to eq @replier
      expect(@reply.grandparent).to eq @post
    end
  end
end
