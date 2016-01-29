class Manage::MessagesController < Manage::ManageController
  before_action :set_building, except: [:index]
  before_action :set_message, only: [:show, :edit, :update, :destroy, :mark_as_read, :mark_as_unread]
  before_action :set_recipient, only: [:new]

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

  # GET /messages/1
  def show
  end

  # GET /messages/new
  def new
    session[:message_return_to] = request.referer
    @message = Message.new(sender: current_user, recipient: @recipient)
    @message.building = @building
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  def create
    @message = Message.new(message_params)
    @message.sender = current_user
    @message.building = @building
    if @message.save
      return_to_url = (session[:message_return_to].present?) ? session[:message_return_to] : manage_messages_url
      session[:message_return_to] = nil
      redirect_to return_to_url, notice: "Message to #{@message.recipient.public_name} was successfully has been sent."
    else
      render :new
    end
  end

  # PATCH/PUT /messages/1
  def update
    if @message.update(message_params)
      redirect_to @message, notice: 'Message was successfully updated.'
    else
      render :edit
    end
  end

  def mark_as_read
    @message.update_attribute(:is_read, true)
    redirect_to :back
  end

  def mark_as_unread
    @message.update_attributes!(is_read: false)
    redirect_to :back
  end

  # DELETE /messages/1
  def destroy
    @message.destroy
    redirect_to messages_url, notice: 'Message was successfully destroyed.'
  end

  private

  def set_message
    @message = Message.find(params[:id])
  end

  def set_recipient
    @recipient = User.find_by_slug(params[:user_id])
  end

  def set_building
    @building = Building.friendly.find(params[:building_id])
  end

  # Only allow a trusted parameter "white list" through.
  def message_params
    params.require(:message).permit(:sender_id, :recipient_id, :body, :messageble_type, :messageble_id, :user_id, :sender_id, :building_id, :is_read)
  end

end
