def load_user
  @user = create(:user, email: "#{SecureRandom.hex(6)}-user@email.com")
end

def load_sent_message
  Message.any_instance.stub(:create_notifications).and_return(true)
  load_valid_building
  @sender = create(:user, email: "sender@email.com")
  @recipient = create(:user, email: "recipeint@email.com")
  @message = create(:message, building: @building, sender: @sender,  recipient: @recipient)
end

