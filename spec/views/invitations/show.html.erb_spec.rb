require 'rails_helper'

RSpec.describe "invitations/show", :type => :view do
  before(:each) do
    @invitation = assign(:invitation, Invitation.create!(
      :user_id => "",
      :building_id => "",
      :token => "",
      :email => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
