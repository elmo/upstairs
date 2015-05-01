require 'rails_helper'

RSpec.describe "classifieds/edit", :type => :view do
  before(:each) do
    @classified = assign(:classified, Classified.create!(
      :id => 1,
      :category_id => 1,
      :title => "MyString",
      :body => "MyText"
    ))
  end

  it "renders the edit classified form" do
    render

    assert_select "form[action=?][method=?]", classified_path(@classified), "post" do

      assert_select "input#classified_id[name=?]", "classified[id]"

      assert_select "input#classified_category_id[name=?]", "classified[category_id]"

      assert_select "input#classified_title[name=?]", "classified[title]"

      assert_select "textarea#classified_body[name=?]", "classified[body]"
    end
  end
end
