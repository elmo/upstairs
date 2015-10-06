require 'rails_helper'

RSpec.describe "verifications/edit", type: :view do
  before(:each) do
    @verification = assign(:verification, Verification.create!(
      :building_id => "",
      :user_id => 1
    ))
  end

  it "renders the edit verification form" do
    render

    assert_select "form[action=?][method=?]", verification_path(@verification), "post" do

      assert_select "input#verification_building_id[name=?]", "verification[building_id]"

      assert_select "input#verification_user_id[name=?]", "verification[user_id]"
    end
  end
end
