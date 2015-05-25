require 'rails_helper'

RSpec.describe "messages/edit", :type => :view do
  before(:each) do
    @message = assign(:message, Message.create!(
      :sender_id => 1,
      :recipient_id => 1,
      :body => "MyText"
    ))
  end

  it "renders the edit message form" do
    render

    assert_select "form[action=?][method=?]", message_path(@message), "post" do

      assert_select "input#message_sender_id[name=?]", "message[sender_id]"

      assert_select "input#message_recipient_id[name=?]", "message[recipient_id]"

      assert_select "textarea#message_body[name=?]", "message[body]"
    end
  end
end
