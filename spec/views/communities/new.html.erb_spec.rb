require 'rails_helper'

RSpec.describe "communities/new", :type => :view do
  before(:each) do
    assign(:building, Building.new())
  end

  it "renders new building form" do
    render

    assert_select "form[action=?][method=?]", communities_path, "post" do
    end
  end
end
