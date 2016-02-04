class Vendor::CommentsController < Manage::ManageController
  before_action :set_commentable
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def index
    @comments = @commentable.comments.order(created_at: :desc).page(params[:page]).per(10)
  end

  def new
    @comment = @commentable.comments.new(user: current_user)
  end

  def edit
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to polymorphic_url([:vendor, :membership, @commentable]), notice: 'Comment was successfully created.'
    else
      render :new
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to polymorphic_url(:vendor, :membership, @commentable), notice: 'Comment was successfully created.'
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    redirect_to polymorphic_url([:vendor, :membership, @commentable]), notice: 'Comment was successfully created.'
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_commentable
    @commentable = Assignment.find(params[:assignment_id]) if params[:assignment_id]
  end

  def comment_params
    params[:comment].permit(:body)
  end

end
