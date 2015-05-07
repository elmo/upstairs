require 'rails_helper'

RSpec.describe "invitations/new", :type => :view do
  before(:each) do
    assign(:invitation, Invitation.new(
      :user_id => "",
      :community_id => "",
      :token => "",
      :email => ""
    ))
  end

  it "renders new invitation form" do
    render

    assert_select "form[action=?][method=?]", invitations_path, "post" do

      assert_select "input#invitation_user_id[name=?]", "invitation[user_id]"

      assert_select "input#invitation_community_id[name=?]", "invitation[community_id]"

      assert_select "input#invitation_token[name=?]", "invitation[token]"

      assert_select "input#invitation_email[name=?]", "invitation[email]"
    end
  end
end
