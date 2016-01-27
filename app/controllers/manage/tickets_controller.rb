class Manage::TicketsController < Manage::ManageController
   before_action :set_ticket, only: [:show, :edit, :update, :destroy]

  def index
    if params[:building_id].present?
      @building = Building.friendly.where(slug: params[:building_id]).first
      scope = @building.tickets
    else
      scope = Post.managed_by(current_user)
    end

    if params[:c]
      @category = Category.friendly.find(params[:c])
      scope = scope.where(category_id: @category.id)
    end

    scope = scope.where(['title like ? or body like ? ', "%#{params[:searchTextField]}%", "%#{params[:searchTextField]}%"]) if params[:searchTextField]
    @tickets = scope.includes(:comments).order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @ticket = Post.find(params[:id])
  end

  private

  def ticket_params
    params[:ticket].permit(:title, :body, :category_id, :searchTextField, :c,  photos: [])
  end

end
