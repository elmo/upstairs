require 'rails_helper'

RSpec.describe "messages/new", :type => :view do
  before(:each) do
    assign(:message, Message.new(
      :sender_id => 1,
      :recipient_id => 1,
      :body => "MyText"
    ))
  end

  it "renders new message form" do
    render

    assert_select "form[action=?][method=?]", messages_path, "post" do

      assert_select "input#message_sender_id[name=?]", "message[sender_id]"

      assert_select "input#message_recipient_id[name=?]", "message[recipient_id]"

      assert_select "textarea#message_body[name=?]", "message[body]"
    end
  end
end
