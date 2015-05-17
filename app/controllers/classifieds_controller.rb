class ClassifiedsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_community
  before_action :set_classified, only: [:show, :edit, :update, :destroy]
  layout 'community'

  # GET /classifieds
  def index
    scope = @community.classifieds
    if params[:category_id]
      @category = Category.find(params[:category_id])
      scope = scope.where(category_id: @category.id)
    end
    @classifieds = scope.page(params[:page]).per(10)
  end

  # GET /classifieds/1
  def show
  end

  # GET /classifieds/new
  def new
    @classified = @community.classifieds.new
  end

  # GET /classifieds/1/edit
  def edit
  end

  # POST /classifieds
  def create
    @classified = Classified.new(classified_params)
    @classified.user = current_user
    @classified.community = @community

    if @classified.save
      redirect_to community_classified_path(@community, @classified), notice: 'Classified was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /classifieds/1
  def update
    if @classified.update(classified_params)
      redirect_to community_classified_path(@community, @classified), notice: 'Classified was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /classifieds/1
  def destroy
    @classified.destroy
    redirect_to community_classifieds_url(@community), notice: 'Classified was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_classified
      @classified = @community.classifieds.friendly.find(params[:id])
    end

    def set_community
      @community = Community.friendly.find(params[:community_id])
    end

    # Only allow a trusted parameter "white list" through.
    def classified_params
      params.require(:classified).permit(:id, :category_id, :title, :body, photos: [])
    end

end
