require 'rails_helper'

RSpec.describe Invitation, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:building) }
  it { should validate_presence_of(:email) }

  describe 'invitation' do
    before(:each) do
      mailer = double
      allow(mailer).to receive(:deliver_now).and_return(true)
      InvitationMailer.any_instance.stub(:invite).and_return(mailer)
      load_valid_building
      load_user
      @valid_attributes = { email: 'user@email.com', user: @user, building: @building }
    end

    it 'creates' do
      expect { Invitation.create(@valid_attributes) }.to change(Invitation, :count).by(1)
    end

    it 'sends' do
      Invitation.any_instance.should_receive(:send_invitation).exactly(1).times
      expect { Invitation.create(@valid_attributes) }.to change(Invitation, :count).by(1)
    end

    describe 'instance' do
      before(:each) do
        @invitation = Invitation.create(@valid_attributes)
      end

      it 'token' do
        expect(@invitation.token.size).to eq 32
      end

      it 'token' do
        expect(@invitation.to_param).to eq @invitation.token
      end
    end
  end
end
