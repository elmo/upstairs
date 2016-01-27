class Manage::EventsController < Manage::ManageController

  def index
    if params[:building_id].present?
      @building = Building.friendly.where(slug: params[:building_id]).first
      scope = @building.events
    else
      scope = Event.managed_by(current_user)
    end

    if params[:c]
      @category = Category.friendly.find(params[:c])
      scope = scope.where(category_id: @category.id)
    end

    scope = scope.where(['title like ? or body like ? ', "%#{params[:searchTextField]}%", "%#{params[:searchTextField]}%"]) if params[:searchTextField]
    @events = scope.includes(:comments).order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @event = Event.find(params[:id])
  end

  private

  def event_params
    params[:event].permit(:title, :body, :searchTextField, :c)
  end

end
