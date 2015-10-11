class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_action :set_building
  before_action :set_recipient, except: [:inbox, :outbox]
  layout 'building'

  # GET /messages
  def index
    @messages = Message.all
  end

  # GET /messages/1
  def show
  end

  # GET /messages/new
  def new
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
    @message.recipient = @recipient
    @message.building = @building
    if @message.save
      redirect_to outbox_path(@building, current_user), notice: "Message to #{@recipient.public_name} was successfully has been sent."
    else
      render :new
    end
  end

  def outbox
    @messages = current_user.sent_messages.order('created_at DESC').page(params[:page]).per(10)
  end

  def inbox
    @messages = current_user.received_messages.order('created_at DESC').page(params[:page]).per(10)
  end

  # PATCH/PUT /messages/1
  def update
    if @message.update(message_params)
      redirect_to @message, notice: 'Message was successfully updated.'
    else
      render :edit
    end
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
