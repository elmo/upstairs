require 'rails_helper'

RSpec.describe "invitations/index", :type => :view do
  before(:each) do
    assign(:invitations, [
      Invitation.create!(
        :user_id => "",
        :building_id => "",
        :token => "",
        :email => ""
      ),
      Invitation.create!(
        :user_id => "",
        :building_id => "",
        :token => "",
        :email => ""
      )
    ])
  end

  it "renders a list of invitations" do
    render
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
