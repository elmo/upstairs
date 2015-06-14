require 'rails_helper'

RSpec.describe "communities/index", :type => :view do
  before(:each) do
    assign(:communities, [
      Building.create!(),
      Building.create!()
    ])
  end

  it "renders a list of communities" do
    render
  end
end
