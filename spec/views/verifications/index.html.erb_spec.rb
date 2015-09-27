require 'rails_helper'

RSpec.describe "verifications/index", type: :view do
  before(:each) do
    assign(:verifications, [
      Verification.create!(
        :building_id => "",
        :user_id => 1
      ),
      Verification.create!(
        :building_id => "",
        :user_id => 1
      )
    ])
  end

  it "renders a list of verifications" do
    render
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
