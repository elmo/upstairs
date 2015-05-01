require 'rails_helper'

RSpec.describe "classifieds/show", :type => :view do
  before(:each) do
    @classified = assign(:classified, Classified.create!(
      :id => 1,
      :category_id => 2,
      :title => "Title",
      :body => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
  end
end
