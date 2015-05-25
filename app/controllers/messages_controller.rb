class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_action :set_community
  layout 'community'

  # GET /messages
  def index
    @messages = Message.all
  end

  # GET /messages/1
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
    @message.community = @community
    set_messegable
    @message.sender = current_user
    @message.recipient = @messegable.user
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  def create
    @message = Message.new(message_params)
    @message.sender = current_user
    if @message.save
      redirect_to @message, notice: 'Message was successfully created.'
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

  # DELETE /messages/1
  def destroy
    @message.destroy
    redirect_to messages_url, notice: 'Message was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    def set_community
      @community = Community.friendly.find(params[:community_id])
    end

    def set_messegable
      if params[:messagable_type].present? and params[:messageable_id].present?
        @messegable = params[:messagable_type].constantize.find(params[:messageable_id])
      else
        @community
      end
    end

    # Only allow a trusted parameter "white list" through.
    def message_params
      params.require(:message).permit(:sender_id, :recipient_id, :body, :messageble_type, :messageble_id, :user_id, :sender_id, :community_id)
    end
end
