class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message, only: [:show, :edit, :update, :destroy, :read, :unread]
  before_action :set_building, except: [:create]
  layout 'building'

  # GET /messages
  def index
    params[:filter] ||= Message::MESSAGE_TO
    if params[:filter] ==  Message::MESSAGE_FROM
      scope = current_user.sent_messages.from_user(current_user)
    else
      scope = current_user.received_messages.to_user(current_user)
    end

    if params[:read].present?
      scope = scope.where(is_read: true) if params[:read] == 'true'
      scope = scope.where(is_read: false) if params[:read] == 'false'
    end

    if params[:searchTextField].present?
      scope = scope.where(['body like ? ', "%#{params[:searchTextField]}%"])
    end

   @messages = scope.page(params[:page]).order(created_at: :desc)
  end

  def show
  end

  def new
    session[:message_return_to] = request.referer
    @message = Message.new(sender: current_user, recipient: @recipient)
    @message.building = @building
  end

  def edit
  end

  def create
    set_recipient
    @message = Message.new(message_params)
    @message.sender = current_user
    @message.recipient = @recipient
    @message.building = @building
    if @message.save
      return_to_url = (session[:message_return_to].present?) ? session[:message_return_to] : building_messages_url(@building)
      session[:message_return_to] = nil
      redirect_to return_to_url, notice: "Message to #{@recipient.public_name} was successfully has been sent."
    else
      render :new
    end
  end

  def update
    if @message.update(message_params)
      redirect_to @message, notice: 'Message was successfully updated.'
    else
      render :edit
    end
  end

  def read
    @message.mark_as_read!
    redirect_to :back
  end

  def unread
    @message.mark_as_unread!
    redirect_to :back
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_message
    @message = Message.find_by_slug(params[:id])
  end

  def set_building
    @building = Building.friendly.find(params[:building_id])
  end

  def set_recipient
    @recipient = User.find_by_slug(params[:user_id])
  end

  # Only allow a trusted parameter "white list" through.
  def message_params
    params.require(:message).permit(:sender_id, :recipient_id, :body, :messageble_type, :messageble_id, :user_id, :sender_id, :building_id)
  end
end
