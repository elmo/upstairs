require 'rails_helper'

RSpec.describe "tickets/edit", :type => :view do
  before(:each) do
    @ticket = assign(:ticket, Ticket.create!(
      :user_id => 1,
      :building_id => 1,
      :title => "MyString",
      :body => "MyText",
      :severity => 1,
      :status => "MyString"
    ))
  end

  it "renders the edit ticket form" do
    render

    assert_select "form[action=?][method=?]", ticket_path(@ticket), "post" do

      assert_select "input#ticket_user_id[name=?]", "ticket[user_id]"

      assert_select "input#ticket_building_id[name=?]", "ticket[building_id]"

      assert_select "input#ticket_title[name=?]", "ticket[title]"

      assert_select "textarea#ticket_body[name=?]", "ticket[body]"

      assert_select "input#ticket_severity[name=?]", "ticket[severity]"

      assert_select "input#ticket_status[name=?]", "ticket[status]"
    end
  end
end
