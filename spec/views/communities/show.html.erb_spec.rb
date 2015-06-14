require 'rails_helper'

RSpec.describe "communities/show", :type => :view do
  before(:each) do
    @building = assign(:building, Building.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
