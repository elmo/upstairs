class CommunitiesController < ApplicationController
  before_action :set_community, only: [:show, :edit, :update]

  def index
    @communities= Community.all
  end

  # GET /communities/1
  def show
   @posts = @community.posts.page(params[:page]).per(10).order('created_at desc')
   @notifications = Notification.all
  end

  # GET /communities/new
  def new
    @community = Community.new
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
    @community = Community.new(community_params)

    if @community.save
      redirect_to @community, notice: 'Community was successfully created.'
    else
      render :new
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_community
      @community = Community.friendly.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def community_params
      params.require(:community).permit(:address_line_one, :address_line_two, :city,:state, :postal_code, photos: [])
    end
end
