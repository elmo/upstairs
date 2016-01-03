class Api::PostsController < ApplicationController
  before_action :get_building, only: [:index,:show,:tips]

  def index
    @posts = @building.posts.page(params[:page]).order(created_at: :desc).per(4)
    render json: @posts
  end

  def tips
    category = Category.find_by_name(Category::CATEGORY_TIPS)
    @posts = @building.posts.where(category_id: category.id ).page(params[:page]).order(created_at: :desc).per(4)
    render json: @posts
  end

  def show
    @post = @building.posts.friendly.find(params[:id])
    render json: @post
  end

  private

  def get_building
    @building = Building.friendly.find(params[:building_id])
  end


end
