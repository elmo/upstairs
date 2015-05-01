require 'rails_helper'

RSpec.describe "classifieds/new", :type => :view do
  before(:each) do
    assign(:classified, Classified.new(
      :id => 1,
      :category_id => 1,
      :title => "MyString",
      :body => "MyText"
    ))
  end

  it "renders new classified form" do
    render

    assert_select "form[action=?][method=?]", classifieds_path, "post" do

      assert_select "input#classified_id[name=?]", "classified[id]"

      assert_select "input#classified_category_id[name=?]", "classified[category_id]"

      assert_select "input#classified_title[name=?]", "classified[title]"

      assert_select "textarea#classified_body[name=?]", "classified[body]"
    end
  end
end
