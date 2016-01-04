class Api::PostsController < Api::ApiController

   before_action :get_building

  def index
    @posts = @building.posts.page(params[:page]).order(created_at: :desc).per(4)
    render json: @posts
  end

  def tips
    category = Category.find_by_name(Category::CATEGORY_TIPS)
    @posts = @building.posts.where(category_id: category.id).page(params[:page]).order(created_at: :desc).per(4)
    render json: @posts
  end

  def show
    @post = @building.posts.find(params[:id])
    render json: @post
  end

  def create
    @post = Post.create(post_params.merge(user_id: current_user.id, postable: @building))
    if @post.errors.empty?
      render json: {post: PostSerializer.new(@post).serializable_hash}, status: :created
    else
      render json: {errors: @post.errors.full_messages}, status: :bad_request
    end
  end

  def update
    @post = @building.posts.find(params[:id])
    if @post.update_attributes(post_params)
      render json: {post: PostSerializer.new(@post).serializable_hash}, status: :ok
    else
      render json: {errors: @post.errors.full_messages}, status: :bad_request
    end
  end

  def destroy
    @post = @building.posts.find(params[:id])
    if @post.destroy
      render json: {post: PostSerializer.new(@post).serializable_hash}, status: :ok
    else
      render json: {post: PostSerializer.new(@post).serializable_hash}, status: :bad_request
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :category_id)
  end

end
