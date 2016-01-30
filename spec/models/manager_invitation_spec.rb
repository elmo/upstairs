require 'rails_helper'
RSpec.describe ManagerInvitation, type: :model do

  it { should belong_to(:user) }
  it { should validate_presence_of(:email) }

  before(:each) do
    load_user
    @manager_invitation = create(:manager_invitation,
				 email: 'user@email.com',
				 user: @user)
  end

  it "defaults to new" do
    expect(@manager_invitation.status).to eq ManagerInvitation::STATUS_NEW
  end

  it "closes" do
    expect{ @manager_invitation.close! }.to change(@manager_invitation, :status).from(ManagerInvitation::STATUS_NEW).to(ManagerInvitation::STATUS_CLOSED)
  end

  it "opens" do
    @manager_invitation.status = ManagerInvitation::STATUS_CLOSED
    expect{ @manager_invitation.open! }.to change(@manager_invitation, :status).from(ManagerInvitation::STATUS_CLOSED).to(ManagerInvitation::STATUS_NEW)
  end

end
