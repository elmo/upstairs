require 'rails_helper'

RSpec.describe "classifieds/index", :type => :view do
  before(:each) do
    assign(:classifieds, [
      Classified.create!(
        :id => 1,
        :category_id => 2,
        :title => "Title",
        :body => "MyText"
      ),
      Classified.create!(
        :id => 1,
        :category_id => 2,
        :title => "Title",
        :body => "MyText"
      )
    ])
  end

  it "renders a list of classifieds" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
