class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  layout 'building'

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
        redirect_to building_post_path(@commentable.postable, @commentable), notice: 'Comment was successfully created.'
      elsif @commentable.class.to_s == 'Ticket'
        redirect_to building_ticket_path(@commentable.building, @commentable), notice: 'Comment was successfully created.'
      elsif @commentable.class.to_s == 'Event'
        redirect_to building_event_path(@commentable.building, @commentable), notice: 'Comment was successfully created.'
      end
    else
      render :new
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      if @commentable.class.to_s == 'Post'
        redirect_to building_post_path(@commentable.postable, @commentable), notice: 'Comment was successfully updated.'
      elsif @commentable.class.to_s == 'Ticket'
        redirect_to building_ticket_path(@commentable.building, @commentable), notice: 'Comment was successfully updated.'
      elsif @commentable.class.to_s == 'Event'
        redirect_to building_event_path(@commentable.building, @commentable), notice: 'Comment was successfully updated.'
      end
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
    @commentable = Event.find(params[:event_id]) if params[:event_id]
    @building = @commentable.postable
  end

  # Only allow a trusted parameter "white list" through.
  def comment_params
    params[:comment].permit(:body)
  end
end
