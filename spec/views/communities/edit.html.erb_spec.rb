require 'rails_helper'

RSpec.describe "communities/edit", :type => :view do
  before(:each) do
    @building = assign(:building, Building.create!())
  end

  it "renders the edit building form" do
    render

    assert_select "form[action=?][method=?]", building_path(@building), "post" do
    end
  end
end
