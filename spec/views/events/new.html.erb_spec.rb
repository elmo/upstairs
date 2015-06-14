require 'rails_helper'

RSpec.describe "events/new", :type => :view do
  before(:each) do
    assign(:event, Event.new(
      :title => "MyString",
      :body => "MyString",
      :building_id => 1,
      :user_id => 1
    ))
  end

  it "renders new event form" do
    render

    assert_select "form[action=?][method=?]", events_path, "post" do

      assert_select "input#event_title[name=?]", "event[title]"

      assert_select "input#event_body[name=?]", "event[body]"

      assert_select "input#event_building_id[name=?]", "event[building_id]"

      assert_select "input#event_user_id[name=?]", "event[user_id]"
    end
  end
end
