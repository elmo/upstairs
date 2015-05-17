class RepliesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment
  before_action :set_reply, only: [:show, :edit, :update, :destroy]
  layout 'community'

  # GET /replies
  def index
    @replies = Comment.all
  end

  # GET /replies/1
  def show
  end

  # GET /replies/new
  def new
    @reply = Reply.new(parent_comment_id: @comment, user: current_user)
  end

  # GET /replies/1/edit
  def edit
  end

  # POST /replies
  def create
    @reply = Reply.new(reply_params)
    @reply.parent_comment_id = @comment.id
    @reply.user = current_user
    if @reply.save
      if @comment.commentable.class.to_s != 'Ticket'
        redirect_to community_post_path(@comment.commentable.postable, @comment.commentable) , notice: "Your reply has been saved."
      else
        redirect_to community_ticket_path(@comment.commentable.community, @comment.commentable), notice: "Your reply has been saved."
      end
    else
      render :new
    end
  end

  # PATCH/PUT /replies/1
  def update
    if @reply.update(reply_params)
      redirect_to @reply, notice: 'Comment was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /replies/1
  def destroy
    @reply.destroy
    redirect_to community_path(@comment.commentable.postable)
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_comment
      @comment = Comment.find(params[:comment_id])
      @community = @comment.commentable.postable
    end

    def set_reply
      @reply = Comment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def reply_params
      params[:reply].permit(:body)
    end
end
