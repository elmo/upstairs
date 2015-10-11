require 'rails_helper'

RSpec.describe VerificationRequest, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:building) }
  it { should have_one(:verification) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:building) }

  describe "new/approval/rejection" do
     before(:each) do
       load_user
       load_valid_building
       load_valid_verfication_request
     end

     it "defaults to pending" do
       expect(VerificationRequest.pending.count).to eq 1
       expect(@verification_request.pending?).to be_truthy
     end

     describe "approve!" do
       before(:each) do
         @verification_request.stub(:notify_user_of_approval).and_return(true)
       end

       it "sets status to approved" do
         expect(VerificationRequest.pending.count).to eq 1
         @verification_request.approve!
         expect(@verification_request.status).to eq VerificationRequest::STATUS_APPROVED
         expect(@verification_request.approved?).to be_truthy
         expect(VerificationRequest.approved.count).to eq 1
       end

       it "calls notifies user upon approval" do
         @verification_request.stub(:notify_user_of_approval).and_return(true)
         expect(@verification_request).to receive(:notify_user_of_approval).exactly(1).times
         @verification_request.approve!
       end

     end

     describe "rejection" do
       before(:each) do
         @verification_request.stub(:notify_user_of_rejection).and_return(true)
       end

       it "is not rejected by default" do
         expect(@verification_request.rejected?).to be_falsey
         expect(VerificationRequest.rejected.count).to eq 0
       end

       it "sets status to rejected" do
         @verification_request.rejected!
         expect(@verification_request.status).to eq VerificationRequest::STATUS_REJECTED
         expect(@verification_request.rejected?).to be_truthy
         expect(VerificationRequest.rejected.count).to eq 1
       end

       it "calls notifies user upon rejection" do
         @verification_request.stub(:notify_user_of_rejection).and_return(true)
         expect(@verification_request).to receive(:notify_user_of_rejection).exactly(1).times
         @verification_request.rejected!
       end
     end

     describe "expiration" do
       before(:each) do
         @verification_request.stub(:notify_user_of_expiration).and_return(true)
       end

       it "is not expired by default" do
         expect(@verification_request.expired?).to be_falsey
         expect(VerificationRequest.rejected.count).to eq 0
       end

       it "sets status to 'expired'" do
         @verification_request.expired!
         expect(@verification_request.status).to eq VerificationRequest::STATUS_EXPIRED
         expect(@verification_request.expired?).to be_truthy
         expect(VerificationRequest.expired.count).to eq 1
       end

       it "calls notifies user upon expiration" do
         @verification_request.stub(:notify_user_of_expiration).and_return(true)
         expect(@verification_request).to receive(:notify_user_of_expiration).exactly(1).times
         @verification_request.expired!
       end

       it "emails user" do
         @verification_request.stub(:notify_user_of_expiration).and_return(true)
         expect(@verification_request).to receive(:notify_user_of_expiration).exactly(1).times
         @verification_request.expired!
       end
     end

     describe "notify_user_of_approval" do
       before(:each) do
         UserMailer.stub(:verification_request_approved).and_return(true)
       end

       it "sends email" do
         expect(UserMailer).to receive(:verification_request_approved).exactly(1).times
         @verification_request.notify_user_of_approval
       end
     end

     describe "notify_user_of_rejection" do
       before(:each) do
         UserMailer.stub(:verification_request_rejected).and_return(true)
       end

       it "sends email" do
         expect(UserMailer).to receive(:verification_request_rejected).exactly(1).times
         @verification_request.notify_user_of_rejection
       end
     end
  end
end
