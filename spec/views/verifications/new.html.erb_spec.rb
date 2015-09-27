require 'rails_helper'

RSpec.describe "verifications/new", type: :view do
  before(:each) do
    assign(:verification, Verification.new(
      :building_id => "",
      :user_id => 1
    ))
  end

  it "renders new verification form" do
    render

    assert_select "form[action=?][method=?]", verifications_path, "post" do

      assert_select "input#verification_building_id[name=?]", "verification[building_id]"

      assert_select "input#verification_user_id[name=?]", "verification[user_id]"
    end
  end
end
