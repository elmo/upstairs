class Api::CommentsController < ApplicationController
  before_action :get_commentable, only: [:index, :show]

  def index
    @comments = @commentable.comments.page(params[:page]).order(created_at: :desc).per(4)
    render json: @comments
  end

  def show
    @comments = @commentable.comments.find(params[:id])
    render json: @comment
  end

  private

  def get_commentable
    @commentable = Post.friendly.find(params[:post_id]) if params[:post_id]
    @commentable = Ticket.find(params[:ticket_id]) if params[:ticket_id]
    @commentable = Event.find(params[:event_id]) if params[:event_id]
  end

end
