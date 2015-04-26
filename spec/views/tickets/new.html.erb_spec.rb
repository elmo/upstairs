require 'rails_helper'

RSpec.describe "tickets/new", :type => :view do
  before(:each) do
    assign(:ticket, Ticket.new(
      :user_id => 1,
      :community_id => 1,
      :title => "MyString",
      :body => "MyText",
      :severity => 1,
      :status => "MyString"
    ))
  end

  it "renders new ticket form" do
    render

    assert_select "form[action=?][method=?]", tickets_path, "post" do

      assert_select "input#ticket_user_id[name=?]", "ticket[user_id]"

      assert_select "input#ticket_community_id[name=?]", "ticket[community_id]"

      assert_select "input#ticket_title[name=?]", "ticket[title]"

      assert_select "textarea#ticket_body[name=?]", "ticket[body]"

      assert_select "input#ticket_severity[name=?]", "ticket[severity]"

      assert_select "input#ticket_status[name=?]", "ticket[status]"
    end
  end
end
