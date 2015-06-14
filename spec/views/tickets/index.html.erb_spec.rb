require 'rails_helper'

RSpec.describe "tickets/index", :type => :view do
  before(:each) do
    assign(:tickets, [
      Ticket.create!(
        :user_id => 1,
        :building_id => 2,
        :title => "Title",
        :body => "MyText",
        :severity => 3,
        :status => "Status"
      ),
      Ticket.create!(
        :user_id => 1,
        :building_id => 2,
        :title => "Title",
        :body => "MyText",
        :severity => 3,
        :status => "Status"
      )
    ])
  end

  it "renders a list of tickets" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
  end
end
