class Manage::MessagesController < Manage::ManageController
  before_action :set_message, only: [:show, :edit, :update, :destroy, :read, :unread]

  # GET /messages
  def index
    params[:filter] ||= Message::MESSAGE_TO
    scope = current_user
    scope = scope.received_messages.unread if params[:filter] == Message::MESSAGE_UNREAD
    scope = scope.received_messages if params[:filter] == Message::MESSAGE_TO
    scope = scope.sent_messages.from_user(current_user) if params[:filter] ==  Message::MESSAGE_FROM
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

  # PATCH/PUT /messages/1
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

  # DELETE /messages/1
  def destroy
    @message.destroy
    redirect_to messages_url, notice: 'Message was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_message
    @message = Message.find_by_slug(params[:id])
  end

  def set_recipient
    @recipient = User.find_by_slug(params[:user_id])
  end

  # Only allow a trusted parameter "white list" through.
  def message_params
    params.require(:message).permit(:sender_id, :recipient_id, :body, :messageble_type, :messageble_id, :user_id, :sender_id, :building_id)
  end

end
