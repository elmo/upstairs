require 'rails_helper'

RSpec.describe Verification, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:building) }
  it { should belong_to(:verifier) }
  it { should belong_to(:verification_request) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:building) }
  it { should validate_presence_of(:verifier) }
  it { should validate_presence_of(:verification_request) }

  describe 'creating' do
    before(:each) do
      load_user
      load_valid_building
      load_verifier
      load_valid_verification_request
      build_verification
      UserMailer.stub(:verification_request_approved).and_return(true)
    end

    it 'saves when valid' do
      expect(@verification.save).to be_truthy
    end

    it 'creates a verifications record' do
      expect { @verification.save }.to change { Verification.count }.by(1)
    end

    it 'updates a verification associated verification_request record' do
      expect { @verification.save }.to change { @verification_request.status }
        .from(VerificationRequest::STATUS_PENDING)
        .to(VerificationRequest::STATUS_APPROVED)
    end

    it 'updates associated user from not verified to verified' do
      expect { @verification.save }.to change { @user.verified_owner_of?(@building) }
        .from(false)
        .to(true)
    end

    it 'updates associated builiding verified count by 1' do
      expect { @verification.save }.to change { Building.verified.count }.from(0).to(1)
    end

    it 'sends email to user' do
      expect(UserMailer).to receive(:verification_request_approved).exactly(1).times
      @verification.save
    end
  end
  describe 'deleting' do
    before(:each) do
      load_user
      load_valid_building
      load_verifier
      load_valid_verification_request
      build_verification
      UserMailer.stub(:verification_request_approved).and_return(true)
      UserMailer.stub(:verification_expired).and_return(true)
      @verification.save
    end

    it 'delets a verifications record' do
      expect { @verification.destroy }.to change { Verification.count }.by(-1)
    end

    it 'updates associated user from verified to not verified' do
      expect { @verification.destroy }.to change { @user.verified_owner_of?(@building) }
        .from(true)
        .to(false)
    end

    it "updates a verification_request to 'expired'" do
      expect { @verification.destroy }.to change { @verification_request.status }
        .from(VerificationRequest::STATUS_APPROVED)
        .to(VerificationRequest::STATUS_EXPIRED)
    end

    it 'updates associated builiding verified count by 1' do
      expect { @verification.destroy }.to change { Building.verified.count }.from(1).to(0)
    end

    it 'sends email to user' do
      expect(UserMailer).to receive(:verification_expired).exactly(1).times
      @verification.destroy
    end
  end
end
