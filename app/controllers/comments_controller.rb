class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  layout 'community'

  # GET /comments
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  def show
  end

  # GET /comments/new
  def new
    @comment = @commentable.comments.new(user: current_user)
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      if @commentable.class.to_s == 'Post'
        redirect_to community_path(@commentable.postable), notice: 'Comment was successfully created.'
      else
        redirect_to community_ticket_path(@commentable.community,@commentable), notice: 'Comment was successfully created.'
      end
    else
      render :new
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      redirect_to @comment, notice: 'Comment was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
    redirect_to comments_url, notice: 'Comment was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def set_commentable
      @commentable = Post.friendly.find(params[:post_id]) if params[:post_id]
      @commentable = Ticket.find(params[:ticket_id]) if params[:ticket_id]
      @community = @commentable.postable
    end

    # Only allow a trusted parameter "white list" through.
    def comment_params
      params[:comment].permit(:body)
    end
end
