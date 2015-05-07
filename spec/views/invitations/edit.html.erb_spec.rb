require 'rails_helper'

RSpec.describe "invitations/edit", :type => :view do
  before(:each) do
    @invitation = assign(:invitation, Invitation.create!(
      :user_id => "",
      :community_id => "",
      :token => "",
      :email => ""
    ))
  end

  it "renders the edit invitation form" do
    render

    assert_select "form[action=?][method=?]", invitation_path(@invitation), "post" do

      assert_select "input#invitation_user_id[name=?]", "invitation[user_id]"

      assert_select "input#invitation_community_id[name=?]", "invitation[community_id]"

      assert_select "input#invitation_token[name=?]", "invitation[token]"

      assert_select "input#invitation_email[name=?]", "invitation[email]"
    end
  end
end
