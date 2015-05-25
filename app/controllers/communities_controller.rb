class CommunitiesController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_community, only: [:show, :edit, :update, :gallery]
  layout :get_layout

  def index
    @communities= Community.all
  end

  # GET /communities/1
  def show
   @posts = @community.posts.page(params[:page]).per(10).order('created_at desc')
   @notifications = @community.notifications.order("created_at desc").limit(5)
  end

  def choose
    @address = params[:address]
  end

  # GET /communities/new
  def new
    @community = Community.new(address: params[:address])
  end

  # GET /communities/1/edit
  def edit
  end

  def update
    if @community.update(community_params)
      redirect_to edit_community_path(@community), notice: 'Community was successfully updated.'
    else
      render :edit
    end
  end

  # POST /communities
  def create
    @community = Community.where(address: community_params[:address]).first
    if @community.present?
      current_user.join(@community)
      redirect_to @community, notice: "Welcome, to #{@community.address}. You are now a member." and return false
    end
    @community = Community.new(community_params)
    if @community.save
      current_user.join(@community)
      redirect_to @community, notice: "Welcome, to #{@community.address}. You are now a member." and return false
    else
      render :new
    end
  end

  def gallery
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_community
      @community = Community.friendly.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def community_params
      params.require(:community).permit(:address, photos: [])
    end

   def get_layout
     ['show', 'gallery'].include?(action_name) ? 'community' : 'application'
   end

end
