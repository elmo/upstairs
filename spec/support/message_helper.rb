def load_sent_message
  Message.any_instance.stub(:create_notifications).and_return(true)
  load_valid_building
  @sender = create(:user, email: 'sender@email.com')
  @recipient = create(:user, email: 'recipient@email.com')
  @message = create(:message, building: @building, sender: @sender,  recipient: @recipient)
end

def create_valid_message
  Message.any_instance.stub(:create_notifications).and_return(true)
  @message = create(:message, building: @building, sender: @sender,  recipient: @recipient, body: 'body')
end
