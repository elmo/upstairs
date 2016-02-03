require 'rails_helper'
RSpec.describe User, type: :model do
  it { should have_many(:activities) }
  it { should have_many(:buildings) }
  it { should have_many(:events) }
  it { should have_many(:invitations) }
  it { should have_many(:memberships) }
  it { should have_many(:notifications) }
  it { should have_many(:replies) }
  it { should have_many(:verifications) }
  it { should have_many(:assignments) }
  it { should have_many(:work_assignments) }
  it { should have_many(:assigned_tickets) }
  it { should belong_to(:invitation) }

  describe 'join' do
    before(:each) do
      load_valid_building
      load_user
    end

    it 'associates user with a building' do
      expect { @user.join(@building) }.to change(Membership, :count).by(1)
      expect(@user.buildings.first).to eq @building
    end

    it 'does not create duplicate membership records' do
      @user.join(@building)
      expect(Membership.count).to eq 1
      expect { @user.join(@building) }.to change(Membership, :count).by(0)
    end
  end

  describe 'leave' do
    before(:each) do
      load_membership
    end

    it 'disassociates user with a building' do
      expect { @user.leave(@building) }.to change(Membership, :count).by(-1)
      expect(@user.buildings).to be_empty
    end
  end

  describe 'text messages' do
    before(:each) do
      load_user
    end

    it 'receives_text_messages? false when ok_to_send_text_messages is false' do
      @user.stub(:ok_to_send_text_messages).and_return(true)
      expect(@user.receives_text_messages?).to eq true
    end

    it 'receives_text_messages? false when ok_to_send_text_messages is true and phone_valid? is false'  do
      @user.stub(:ok_to_send_text_messages).and_return(true)
      @user.stub(:phone_valid?).and_return(false)
      expect(@user.receives_text_messages?).to eq false
    end

    it 'receives_text_messages? true when ok_to_send_text_messages is true and phone_valid? is true'  do
      @user.stub(:ok_to_send_text_messages).and_return(true)
      @user.stub(:phone_valid?).and_return(true)
      expect(@user.receives_text_messages?).to eq true
    end
  end

  describe 'phone_valid?' do
    before(:each) do
      @user = User.new
    end

    it 'false when number of digits is 9' do
      @user.phone = '123456789'
      expect(@user.phone_valid?).to eq false
    end

    it 'false when number of digits is 13' do
      @user.phone = '1234567890123'
      expect(@user.phone_valid?).to eq false
    end

    it 'true when number of digits is 10,11,12' do
      @user.phone = '12345678901'
      expect(@user.phone_valid?).to eq true
      @user.phone = '123456789011'
      expect(@user.phone_valid?).to eq true
      @user.phone = '123456789012'
      expect(@user.phone_valid?).to eq true
    end
  end

  describe 'admin?' do
    before(:each) do
      load_user
    end

    it 'is false when user does not have role :admin' do
      expect(@user.admin?).to eq false
    end

    it 'is true when user has role :admin' do
      @user.add_role(:admin)
      expect(@user.admin?).to eq true
    end
  end

  describe 'verifier?' do
    before(:each) do
      load_user
    end

    it 'is false when user does not have role :verifier' do
      expect(@user.verifier?).to eq false
    end

    it 'is true when user has role :admin' do
      @user.add_role(:verifier)
      expect(@user.verifier?).to eq true
    end
  end

  describe 'owns?' do
    before(:each) do
      load_valid_building
      load_user
      Alert.any_instance.stub(:create_notifications).and_return(true)
    end

    it 'is true when user created object' do
      @alert = create(:alert, user: @user, building: @building)
      expect(@user.owns?(@alert)).to eq true
    end

    it 'is true when user created object' do
      @user2 = create(:user, email: 'user2@gmail.com')
      @alert = create(:alert, user: @user2, building: @building)
      expect(@user.owns?(@alert)).to eq false
    end
  end

  describe 'public_name' do
    before(:each) do
      load_user
    end

    it 'returns username if permitted and present' do
      @user.stub(:use_my_username?).and_return(true)
      @user.username = 'username'
      expect(@user.public_name).to eq 'username'
    end

    it "returns 'anonymous' if not permitted and present" do
      @user.stub(:use_my_username?).and_return(false)
      @user.username = 'username'
      expect(@user.public_name).to eq 'anonymous'
    end

    it "returns 'anonymous' if permitted and blank" do
      @user.stub(:use_my_username?).and_return(false)
      @user.username = 'username'
      expect(@user.public_name).to eq 'anonymous'
    end
  end

  describe 'manager_of?' do
    before(:each) do
      load_user
      load_valid_building
    end

    it 'is false if user does not have landlord or manager membership for building' do
      expect(@user.manager_of?(@building)).to eq false
    end

    it 'is true when user has manager membership for building' do
      @user.make_manager(@building)
      expect(@user.manager_of?(@building)).to eq true
    end
  end

  describe 'sent messages' do
    before(:each) do
      load_sent_message
    end

    it 'sender has sent message' do
      expect(@sender.sent_messages.first).to eq @message
      expect(@sender.sent_messages.count).to eq 1
    end

    it 'recipient has recieved message' do
      expect(@recipient.received_messages.first).to eq @message
      expect(@recipient.received_messages.count).to eq 1
    end
  end

  describe 'default_building' do
    before(:each) do
      load_user
      load_valid_building
    end

    it 'is nil before user joins building' do
      expect(@user.default_building).to be_nil
    end

    it 'is @building after user joins building' do
      @user.join(@building)
      expect(@user.default_building).to eq @building
    end
  end

  describe 'make/revoke manager membership' do
    before(:each) do
      load_user
      load_valid_building
    end

    it 'add manager membership' do
      expect { @user.make_manager(@building) }.to change(Membership, :count).by(1)
      expect(@user.managed_properties.first).to eq @building
      expect(@user.managerships.count).to eq 1
    end

    it 'revoke manager membership' do
      @user.make_manager(@building)
      expect(@user.managed_properties.first).to eq @building
      @user.revoke_manager(@building)
      expect(@user.managed_properties).to be_empty
    end
  end

  describe 'to_param' do
    before(:each) do
      @user = create(:user, email: 'user@email.com')
    end

    it 'should be 10 chars long' do
      expect(@user.to_param.length).to eq 9
      expect(@user.to_param).to eq @user.slug
    end
  end

  describe 'landlord?' do
    before(:each) do
      load_valid_building
      load_user
    end

    it 'is false when user has no landlord membership for bulding' do
      expect(@user.landlord?).to be false
    end

    it 'is true when user has landlord membership for bulding' do
      @user.make_landlord(@building)
      expect(@user.landlord?).to be true
    end
  end

  describe 'ships' do
    before(:each) do
      load_valid_building
      load_user
    end

    it 'creates landlord membership role' do
      @user.make_landlord(@building)
      expect(@user.landlordships.count).to eq 1
    end

    it 'creates manager membership role' do
      @user.make_manager(@building)
      expect(@user.managerships.count).to eq 1
    end

    it 'creates tenant role' do
      @user.make_tenant(@building)
      expect(@user.tenantships.count).to eq 1
    end

    it 'creates guest role' do
      @user.make_guest(@building)
      expect(@user.guestships.count).to eq 1
    end

    describe 'revocations' do
      it 'creates landlord membership role' do
        @user.make_landlord(@building)
        expect(@user.landlordships.count).to eq 1
        @user.revoke_landlord(@building)
        expect(@user.landlordships.count).to eq 0
      end

      it 'creates manager membership role' do
        @user.make_manager(@building)
        expect(@user.managerships.count).to eq 1
        @user.revoke_manager(@building)
        expect(@user.managerships.count).to eq 0
      end

      it 'creates tenant role' do
        @user.make_tenant(@building)
        expect(@user.tenantships.count).to eq 1
        @user.revoke_tenant(@building)
        expect(@user.tenantships.count).to eq 0
      end

      it 'creates guest role' do
        @user.make_guest(@building)
        expect(@user.guestships.count).to eq 1
        @user.revoke_guest(@building)
        expect(@user.guestships.count).to eq 0
      end
    end # revocations
  end # ..ships

  describe 'landlord_of_building?' do
    before(:each) do
      load_valid_building
      load_user
    end

    it 'is false when user has no landlord membership for bulding' do
      expect(@user.landlord_of?(@building)).to be false
    end

    it 'is true when user has landlord membership for bulding' do
      @user.make_landlord(@building)
      expect(@user.landlord_of?(@building)).to be true
    end
  end

  describe 'change membership' do
    before(:each) do
      load_valid_building
      load_user
      @user.make_guest(@building)
    end

    it "changes membership to 'tenant' " do
      expect(@user.guestships.count).to eq 1
      @user.change_membership(building: @building, membership_type: Membership::MEMBERSHIP_TYPE_TENANT)
      expect(@user.tenantships.count).to eq 1
    end

    it "does not change membership to 'foo' " do
      expect(@user.guestships.count).to eq 1
      @user.change_membership(building: @building, membership_type: 'foo')
      expect(@user.guestships.count).to eq 1
    end
  end

  describe 'grant/revoke' do
    before(:each) do
      load_valid_building
      load_user
    end

    describe 'permissions' do
      describe 'permitted_to_grant_landlordship?' do
        it 'true when admin' do
          @user.make_admin
          expect(@user.permitted_to_grant_landlordship?(@building)).to eq true
        end

        it 'false when not admin' do
          expect(@user.permitted_to_grant_landlordship?(@building)).to eq false
        end
      end

      describe 'permitted_to_revoke_landlordship?' do
        it 'true when admin' do
          @user.make_admin
          expect(@user.permitted_to_revoke_landlordship?(@building)).to eq true
        end

        it 'false when not admin' do
          expect(@user.permitted_to_revoke_landlordship?(@building)).to eq false
        end
      end

      describe 'permitted_to_grant_manager?' do
        it 'true when owner of building' do
          @user.make_landlord(@building)
          expect(@user.permitted_to_grant_managership?(@building)).to eq true
        end

        it 'false when not owner of building' do
          expect(@user.permitted_to_grant_managership?(@building)).to eq false
        end
      end

      describe 'permitted_to_revoke_manager?' do
        it 'true when landlord of building' do
          @user.make_landlord(@building)
          expect(@user.permitted_to_revoke_managership?(@building)).to eq true
        end

        it 'false when not landlord of building' do
          expect(@user.permitted_to_revoke_managership?(@building)).to eq false
        end
      end

      describe 'permitted_to_grant_tenantship?' do
        it 'true when owner of building' do
          @user.make_landlord(@building)
          expect(@user.permitted_to_grant_tenantship?(@building)).to eq true
        end

        it 'false when not owner of building' do
          expect(@user.permitted_to_grant_tenantship?(@building)).to eq false
        end
      end

      describe 'permitted_to_revoke_tenant?' do
        it 'true when landlord of building' do
          @user.make_landlord(@building)
          expect(@user.permitted_to_revoke_tenantship?(@building)).to eq true
        end

        it 'false when not landlord of building' do
          expect(@user.permitted_to_revoke_tenantship?(@building)).to eq false
        end
      end
    end
  end

  describe 'grant/revoke' do
    before(:each) do
      load_valid_building
      load_user
      @user.join(@building)
      @membership = @user.memberships.first
      load_landlord(@building)
    end

    describe 'grants' do
      it 'landlordship' do
        load_admin
        @admin.grant(@membership, Membership::MEMBERSHIP_TYPE_LANDLORD)
        expect(@user.landlordships).to eq @user.memberships
      end

      it 'landlordship raises when user is not admin' do
        load_landlord(@building)
        expect { @landlord.grant(@membership, Membership::MEMBERSHIP_TYPE_LANDLORD) }.to raise_error('Unable to grant permission')
      end

      it 'managership' do
        @landlord.grant(@membership, Membership::MEMBERSHIP_TYPE_MANAGER)
        expect(@user.managerships.count).to eq 1
      end

      it 'tenantship' do
        @landlord.grant(@membership, Membership::MEMBERSHIP_TYPE_TENANT)
        expect(@user.tenantships.count).to eq 1
      end
    end

    describe 'revokes' do
      it 'landlordship' do
        load_admin
        @admin.grant(@membership, Membership::MEMBERSHIP_TYPE_LANDLORD)
        expect(@user.landlordships).to eq @user.memberships
        @admin.revoke(@membership, Membership::MEMBERSHIP_TYPE_LANDLORD)
        expect(@user.landlordships).to be_empty
      end

      it 'landlordship raises when user is not admin' do
        load_landlord(@building)
        expect { @landlord.revoke(@membership, Membership::MEMBERSHIP_TYPE_LANDLORD) }.to raise_error('Unable to revoke permission')
      end

      it 'managership' do
        @landlord.grant(@membership, Membership::MEMBERSHIP_TYPE_MANAGER)
        expect(@user.managerships.count).to eq 1
        @landlord.revoke(@membership, Membership::MEMBERSHIP_TYPE_MANAGER)
        expect(@user.managerships).to be_empty
      end

      it 'tenantship' do
        @landlord.grant(@membership, Membership::MEMBERSHIP_TYPE_TENANT)
        expect(@user.tenantships.count).to eq 1
        @landlord.revoke(@membership, Membership::MEMBERSHIP_TYPE_TENANT)
        expect(@user.tenantships).to be_empty
      end
    end
  end

  describe 'owned_properites' do
    before(:each) do
      load_valid_building
      load_user
    end

    it 'should be empty when user has no landlord membership' do
      expect(@user.owned_properties).to be_empty
    end

    it 'should not be empty when user has no landlord membership' do
      @user.make_landlord(@building)
      expect(@user.owned_properties.first).to eq @building
    end
  end

  describe 'managed properties' do
    before(:each) do
      load_valid_building
      load_user
    end

    it 'should be empty when user has no manager membership' do
      expect(@user.managed_properties).to be_empty
    end

    it 'should not be empty when user has no manager membership' do
      @user.make_manager(@building)
      expect(@user.managed_properties.first).to eq @building
    end
  end

  describe 'verified_owner_of?' do
    before(:each) do
      load_valid_building
      load_user
      load_verifier
      load_valid_verification_request
    end
    it 'should be false when no verification record exists' do
      expect(@user.verified_owner_of?(@building)).to be_falsey
    end
    it 'should be true when a verification record exists' do
      @user.verify_ownership(building: @building, verifier: @verifier, verification_request: @verification_request)
      expect(@user.verified_owner_of?(@building)).to be_truthy
    end
  end

  describe 'verify_ownership' do
    before(:each) do
      load_valid_building
      load_user
      load_verifier
      load_valid_verification_request
    end

    it 'requires building' do
      expect { @user.verify_ownership(building: nil, verifier: @verifier, verification_request: @verification_request) }.to change(Verification, :count).by(0)
    end

    it 'requires verififier' do
      expect { @user.verify_ownership(building: @building, verifier: nil, verification_request: @verification_request) }.to change(Verification, :count).by(0)
    end

    it 'verifiy ownership' do
      expect { @user.verify_ownership(building: @building, verifier: @verifier, verification_request: @verification_request) }.to change(Verification, :count).by(1)
      expect(@user.verified_owner_of?(@building)).to be_truthy
    end
  end
end
