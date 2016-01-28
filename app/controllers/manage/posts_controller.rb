class Manage::PostsController < Manage::ManageController
   before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    if params[:building_id].present?
      @building = Building.friendly.where(slug: params[:building_id]).first
      scope = @building.posts
    else
      scope = Post.managed_by(current_user)
    end

    if params[:category_id]
      @category = Category.friendly.find(params[:category_id])
      scope = scope.where(category_id: @category.id)
    end

    if params[:user_id]
      @user = User.find_by(slug: params[:user_id] )
      scope = scope.where(user_id: @user.id)
    end

    scope = scope.where(['title like ? or body like ? ', "%#{params[:searchTextField]}%", "%#{params[:searchTextField]}%"]) if params[:searchTextField]
    @posts = scope.includes(:comments).order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @post = Post.find(params[:id])
  end

  private

  def post_params
    params[:post].permit(:title, :body, :category_id, :searchTextField, :c,  photos: [])
  end

end
