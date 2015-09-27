require 'rails_helper'

RSpec.describe "verifications/show", type: :view do
  before(:each) do
    @verification = assign(:verification, Verification.create!(
      :building_id => "",
      :user_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/1/)
  end
end
