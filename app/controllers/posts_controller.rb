class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_postable
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  layout 'building'

  # GET /posts
  def index
    scope = @building.posts
    if params[:category_id]
      @category = Category.find(params[:category_id])
      scope = scope.where(category_id: @category.id)
    end
    scope = scope.where(["title like ? or body like ? ", "%#{params[:q]}%", "%#{params[:q]}%"]) if params[:q]
    scope.page(params[:page]).per(10)
    @posts = scope.page(params[:page]).per(10)
  end

  # GET /posts/1
  def show
  end

  # GET /posts/new
  def new
    @post = @postable.posts.new(user: current_user)
  end

  # GET /posts/1/edit
  def edit
    @post = @postable.posts.friendly.find(params[:id])
  end

  # POST /posts
  def create
    @post = @postable.posts.new(post_params)
    @post.user = current_user
    if @post.save
      redirect_to building_post_path(@postable, @post), notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      redirect_to building_post_path(@postable, @post), notice: 'Post was successfully created.'
    else
      render :edit
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.

  def set_postable
    @postable = Building.friendly.find(params[:building_id])
    @building = @postable
  end

  def set_post
    @post = @postable.posts.friendly.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def post_params
    params[:post].permit(:title, :body, :category_id,  photos: [])
  end
end
